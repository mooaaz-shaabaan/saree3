import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saree3/bussines_logic/user_maps/user_maps_state.dart';

import '../../constants/constants.dart';

class UserMapsLogic extends Cubit<UserMapsStatee> {
  UserMapsLogic() : super(UserMapsInitial());

  void initialize() {
    _initLocation();
  }

  Set<Marker> driverMarkers = {};
  BitmapDescriptor? driverIcon;
  Position? userPosition;
  StreamSubscription<Position>? positionStream;
  String? userUID;
  String? image;
  bool _movedOnce = false; // 👈 عشان الكاميرا تتحرك أول مرة بس
  PolylinePoints polylinePoints = PolylinePoints(apiKey: googleAPIKey);
  Map<String, LatLng> _driversLocations = {}; // تخزين مواقع كل السواقين

  late GoogleMapController _mapController;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    _loadMapStyle();
    Future.delayed(Duration(milliseconds: 500), () {});
    emit(SetMapController());
  }

  //دالة تنقل الكاميرا على لوكيشن اليوزر
  Future<void> moveToUserPosition() async {
    if (userPosition == null) return;
    final GoogleMapController controller = await _mapController;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userPosition!.latitude, userPosition!.longitude),
          zoom: 15,
        ),
      ),
    );
    emit(MoveToUserPosition());
  }

  // دالة تحمل ستايل الماب
  void _loadMapStyle() async {
    try {
      final String style = await rootBundle.loadString("assets/mapStyle.json");
      (_mapController).setMapStyle(style);
      emit(LoadMapStyle());
    } catch (e) {
      emit(ErrorState("Failed to load map style: $e"));
    }
  }

  // دالة تحمل أيقونة الطيار
  Future<BitmapDescriptor> _loadIcon() async {
    final icon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(50, 50)),
      "assets/images/motorcycle.png",
    );
    driverIcon = icon;
    emit(LoadIcon());
    return icon;
  }

  // دالة تجيب لوكيشن اليوزر
  Future<void> _initLocation() async {
    await checkLocationPermission();

    userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          userPosition = position;

          // 👈 الكاميرا تتحرك أول مرة بس
          if (!_movedOnce) {
            moveToUserPosition();
            _movedOnce = true;
          }
        });

    await _loadIcon();
    _listenToDrivers();
    emit(InitLocation());
  }

  // دالة تعمل check على صلاحيه الموقع والموقع فى الجهاز شغال ولا لا
  Future<bool> checkLocationPermission() async {
    // 1️⃣ التأكد من تفعيل خدمة الموقع
    if (!await Geolocator.isLocationServiceEnabled()) {
      emit(ErrorState("خدمة الموقع مش شغالة"));
      return false;
    }

    // 2️⃣ التحقق من صلاحية الوصول للموقع
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(ErrorState("اليوزر رفض صلاحية الموقع"));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(ErrorState("الصلاحية مرفوضة بشكل دائم"));
      return false;
    }


    emit(CheckLocationPermission());
    return true;
  }

  void _listenToDrivers() {
    FirebaseDatabase.instance.ref("drivers").onValue.listen((event) async {
      final data = event.snapshot.value as Map?;
      if (data == null || userPosition == null) {
        print("⚠️ No drivers or no user location");

        driverMarkers = {};
        _driversLocations.clear();
        return;
      }

      Set<Marker> newMarkers = {};
      Map<String, LatLng> updatedLocations = {};

      for (var entry in data.entries) {
        final uid = entry.key;
        final value = entry.value as Map?;

        if (value == null) continue;

        final latValue = value["driver_lat"];
        final lngValue = value["driver_long"];
        final name = value['driver_name'] ?? "Driver Name";

        if (latValue == null || lngValue == null) {
          continue;
        }

        final lat = (latValue as num).toDouble();
        final lng = (lngValue as num).toDouble();

        updatedLocations[uid] = LatLng(lat, lng);

        try {
          final response = await polylinePoints.getRouteBetweenCoordinatesV2(
            request: RoutesApiRequest(
              origin: PointLatLng(
                userPosition!.latitude,
                userPosition!.longitude,
              ),
              destination: PointLatLng(lat, lng),
              travelMode: TravelMode.driving,
              routingPreference: RoutingPreference.trafficAware,
              units: Units.metric,
            ),
          );

          if (response.routes.isNotEmpty) {
            final route = response.routes.first;
            double distance = route.distanceKm ?? 999;

            if (distance <= 5) {
              newMarkers.add(
                Marker(
                  markerId: MarkerId(uid),
                  position: LatLng(lat, lng),
                  icon: driverIcon ?? BitmapDescriptor.defaultMarker,
                  infoWindow: InfoWindow(
                    title: name,
                  ),
                  onTap: () {
                    print("Tapped on driver $uid");
                  },
                ),
              );
            }
          }
        } catch (e) {
          print("❌ Error while getting route for driver $uid: $e");
        }
      }

      driverMarkers = newMarkers;
      _driversLocations = updatedLocations;
      emit(ListenToDrivers());
    });
  }
}
