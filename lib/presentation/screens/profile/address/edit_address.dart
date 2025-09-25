import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../bussines_logic/address/address_cubit.dart';
import '../../../../bussines_logic/address/address_state.dart';
import '../../../../constants/constants.dart';
import '../../../../model/address/address_model.dart';
import '../../../widgets/profile/customTextButton.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({
    super.key,
    required this.address,
    required this.index,
  });
  final AddressModel address;
  final int index;

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _addressCtrl = TextEditingController();
  final _apartmentCtrl = TextEditingController();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Position? _userPosition;
  StreamSubscription<Position>? _positionStream;
  bool _movedOnce = false; // 👈 عشان الكاميرا تتحرك أول مرة بس
  LatLng? _center;
  String _address = "Drag the map to get the address";
  String? userUID;
  int _firstAddress = 0;
  List<String> type = ["HOME", "WORK", "OTHER"];

  double? lat;
  double? lng;
  String? locality;
  String? country;

  int? isSelectedTypeAddress;
  bool _showForm = true;

  @override
  void initState() {
    _initLocation();
    userUID = FirebaseAuth.instance.currentUser!.uid;
    _addressCtrl.text = widget.address.address;
    _apartmentCtrl.text = widget.address.apartment;
    isSelectedTypeAddress = widget.address.typeIndex;
    _center = LatLng(widget.address.lat, widget.address.lng);
    super.initState();
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _apartmentCtrl.dispose();
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Google Map
            _googleMapWidget(),

            /// Back & Go my  location
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: Icon(
                          Icons.location_history,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                        onPressed: () => _moveToUserPosition(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              offset: _showForm ? Offset(0, 0) : Offset(0, 1),
              child: _addressForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressForm() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 315.h,
        padding: EdgeInsets.only(
          top: 30.h,
          bottom: 20.h,
          right: 20.w,
          left: 20.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: Column(
          children: [
            _customTextFormField(
              controller: _addressCtrl,
              labelText: 'Address',
              prefixIcon: true,
            ),
            Gap(15.h),
            _customTextFormField(
              controller: _apartmentCtrl,
              labelText: 'Apartment',
            ),
            Gap(12.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                type.length,
                (i) => _addressName(text: type[i], selected: i),
              ),
            ),

            Gap(16.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                minimumSize: Size.fromHeight(50.h),
              ),
              onPressed: _editAddress,
              child: customTextButton(text: "EDIT LOCATION"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressName({required String text, required int selected}) {
    return BlocBuilder<AddressLogic, AddressState>(
      builder: (context, state) {
        final addressLogic = context.read<AddressLogic>();

        return ChoiceChip(
          label: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: isSelectedTypeAddress == selected
                  ? AppColors.white
                  : Colors.black,
            ),
          ),
          selected: isSelectedTypeAddress == selected,
          onSelected: (_) {
            addressLogic.updateIsSelected(selected);
            isSelectedTypeAddress = selected;
          },
          backgroundColor: const Color(0xffF0F5FA),
          selectedColor: AppColors.primary,
          checkmarkColor: Colors.white,
        );
      },
    );
  }

  Widget _customTextFormField({
    required TextEditingController controller,
    required String labelText,
    bool prefixIcon = false,
    bool enabled = true,
    IconData icon = Icons.location_on,
  }) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 14.sp),
        prefixIcon: prefixIcon ? Icon(icon, size: 20.sp) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  Widget _googleMapWidget() {
    return Stack(
      children: [
        GoogleMap(
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _userPosition != null
                ? LatLng(_userPosition!.latitude, _userPosition!.longitude)
                : (LatLng(widget.address.lat, widget.address.lng)),
            zoom: 17.5,
          ),
          onMapCreated: (GoogleMapController controller) {
            if (!_controller.isCompleted) {
              _controller.complete(controller);
            }
            _loadMapStyle();
          },
          onCameraMoveStarted: () => setState(() => _showForm = false),
          onCameraIdle: () {
            _getAddressFromLatLng(_center!);
            setState(() => _showForm = true);
          },
          onCameraMove: (position) => _center = position.target,
        ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: Text(_address, textAlign: TextAlign.center),
              ),
              Gap(7.h),
              const Icon(Icons.location_on, size: 50, color: Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  void _loadMapStyle() async {
    final String style = await DefaultAssetBundle.of(
      context,
    ).loadString("assets/mapStyle.json");
    (await _controller.future).setMapStyle(style);
  }

  // دالة تجيب العنوان من الإحداثيات
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        setState(() {
          Placemark place = placemarks.first;

          lat = position.latitude;
          lng = position.longitude;
          locality = place.locality;
          country = place.country;
          _address = "${place.locality}, ${place.country}";
          if (_firstAddress >= 2) {
            _addressCtrl.text = "${place.locality}, ${place.country}";
          }
        });
        _firstAddress++;
      }
    } catch (e) {
      setState(() {
        _address = "$e";
        print("//////////////////////////////////////////////////////$e");
        // _address = "حدث خطأ تأكد من أن الموقع صحيح";
      });
    }
  }

  // دالة تعمل check على صلاحيه الموقع والموقع فى الجهاز شغال ولا لا
  Future<bool> _checkLocationPermission() async {
    // 1- Check if location service is enabled (GPS شغال ولا لأ)
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // هنا ممكن تطلع AlertDialog أو SnackBar تقول لليوزر يشغل الموقع
      print("خدمة الموقع مش شغالة");
      return false;
    }

    // 2- Check permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // اطلب الصلاحية
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("اليوزر رفض الصلاحية");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // اليوزر عامل بلوك للتطبيق من إعدادات النظام
      print("الصلاحية مرفوضة بشكل دائم");
      return false;
    }

    // لو وصلنا هنا يبقى الخدمة شغالة والصلاحية موجودة ✅
    return true;
  }

  // دالة تجيب مكان اليوزر
  Future<void> _initLocation() async {
    await _checkLocationPermission();

    _userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {});

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          setState(() {
            _userPosition = position;
          });

          // 👈 الكاميرا تتحرك أول مرة بس
          if (!_movedOnce) {
            _moveToUserPosition();
            _movedOnce = true;
          }
        });
  }

  // دالة تحرك الكاميرا على مكان اليوزر
  Future<void> _moveToUserPosition() async {
    if (_userPosition == null) return;
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          zoom: 17.5,
        ),
      ),
    );
  }

  void _editAddress() {
    if (widget.address.type.isEmpty || _addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final newAddress = AddressModel(
      id: widget.address.id,
      type: type[isSelectedTypeAddress!],
      typeIndex: isSelectedTypeAddress!,
      address: _addressCtrl.text.trim(),
      icon: setIcon(text: type[isSelectedTypeAddress!]),
      color: setColor(text: type[isSelectedTypeAddress!]),
      lat: 0,
      lng: 0,
      apartment: _apartmentCtrl.text,
    );

    context.read<AddressLogic>().editAddress(widget.index, newAddress);

    Navigator.pop(context);
  }

  IconData setIcon({required String text}) {
    IconData icon = Icons.location_on;
    if (text == "WORK") {
      icon = Icons.work_outline;
    } else if (text == "HOME") {
      icon = Icons.home_outlined;
    }
    return icon;
  }

  Color setColor({required String text}) {
    Color icon = AppColors.green;
    if (text == "WORK") {
      icon = AppColors.purple;
    } else if (text == "HOME") {
      icon = AppColors.blue;
    }
    return icon;
  }
}
