import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/constants.dart';
import '../../model/driverModel.dart';

part 'tracking_order_map_state.dart';

class TrackingOrderMapLogic extends Cubit<TrackingOrderMapState> {
  TrackingOrderMapLogic() : super(TrackingInitial());

  void initialize() {
    _initLocation();
  }

  final Set<Marker> driverMarkers = {};
  BitmapDescriptor? driverIcon;
  Position? userPosition;
  StreamSubscription<Position>? positionStream;
  String? useruid;
  double? latitudeDriver;
  double? longtudeDriver;
  String etaText = ''; // الوقت كنص جاهز للعرض
  double? routeKm; // المسافة بالكيلومتر
  List<LatLng> polyPoints = [];
  PolylinePoints polylinePoints = PolylinePoints(apiKey: googleAPIKey);

  late GoogleMapController _mapController;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    _loadMapStyle();
    Future.delayed(Duration(milliseconds: 500), () {
      fitCameraToBounds();
    });
    emit(SetMapController());
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
      Images.iconDriver,
    );
    driverIcon = icon;
    emit(LoadIcon());
    return icon;
  }

  // دالة تجيب بيانات الرحله
  void _listenToLocations() {
    final ref = FirebaseDatabase.instance.ref("orders");
    String userUID = FirebaseAuth.instance.currentUser!.uid;

    ref.onValue.listen((event) {
      if (event.snapshot.value == null) return; // ✅ لازم الأول عشان مايكسرش

      final data = event.snapshot.value as Map<dynamic, dynamic>;

      driverMarkers.clear(); // مسح الماركرات القديمة

      data.forEach((key, value) {
        final model = DriverModel.fromMap(value);

        if (model.userUID == userUID) {
          latitudeDriver = model.lat;
          longtudeDriver = model.lng;

          driverMarkers.add(
            Marker(
              markerId: MarkerId(model.userUID),
              position: LatLng(latitudeDriver!, longtudeDriver!),
              icon: driverIcon!,
              // infoWindow: InfoWindow(title: model.driver_name),
            ),
          );

          _getPolyPoints();
          fitCameraToBounds();
        }
      });
      emit(ListenToLocations());
    });
  }

  // دالة تجيب لوكيشن اليوزر
  Future<void> _initLocation() async {
    userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) async {
          userPosition = position;

          // 👈 الكاميرا تتحرك أول مرة بس
          // if (!_movedOnce) {
          //   _movedOnce = true;
          //   _mapController.animateCamera(
          //     CameraUpdate.newLatLng(
          //       LatLng(position.latitude, position.longitude),
          //     ),
          //   );
          // }
          fitCameraToBounds();
        });

    await _loadIcon();
    _listenToLocations();
    emit(InitLocation());
  }

  // دالة تظهر خط الرحلة
  Future<void> _getPolyPoints() async {
    if (userPosition == null) return;

    try {
      final response = await polylinePoints.getRouteBetweenCoordinatesV2(
        request: RoutesApiRequest(
          origin: PointLatLng(userPosition!.latitude, userPosition!.longitude),
          destination: PointLatLng(latitudeDriver!, longtudeDriver!),
          travelMode: TravelMode.driving,
          routingPreference: RoutingPreference.trafficAware,
          units: Units.metric,
        ),
      );

      if (response.routes.isNotEmpty) {
        final route = response.routes.first;

        // نقاط الخط
        polyPoints = (route.polylinePoints ?? [])
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        // المسافة بالكيلومتر
        routeKm =
            (route.distanceKm ??
            (route.distanceMeters != null
                ? route.distanceMeters! / 1000.0
                : null));

        // الوقت بالدقائق (يفضل durationMinutes لو متاح، وإلا staticDurationMinutes)
        final mins = route.durationMinutes ?? route.staticDurationMinutes ?? 0;
        etaText = _formatMinutes(mins);
      }
      emit(GetPolyPoints());
    } catch (e) {
      print("ERROR V2 POLYLINE => $e");
      emit(ErrorState("Failed to get polyline: $e"));
    }
  }

  // دالة تحسب وقت الرحلة
  String _formatMinutes(double minutes) {
    final m = minutes.round();
    emit(FormatMinutes());
    return "$m min";
  }

  // الكاميرا تبقا مع السواق واليوزر
  Future<void> fitCameraToBounds() async {
    if (userPosition == null ||
        latitudeDriver == null ||
        longtudeDriver == null) {
      return;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        userPosition!.latitude < latitudeDriver!
            ? userPosition!.latitude
            : latitudeDriver!,
        userPosition!.longitude < longtudeDriver!
            ? userPosition!.longitude
            : longtudeDriver!,
      ),
      northeast: LatLng(
        userPosition!.latitude > latitudeDriver!
            ? userPosition!.latitude
            : latitudeDriver!,
        userPosition!.longitude > longtudeDriver!
            ? userPosition!.longitude
            : longtudeDriver!,
      ),
    );

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        100,
      ), // padding = مسافة حوالين النقطتين
    );
    emit(FitCameraToBounds());
  }

  @override
  Future<void> close() {
    positionStream?.cancel();
    return super.close();
  }
}
