import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bussines_logic/tracking_order_map/tracking_order_map_cubit.dart';
import '../../../constants/constants.dart';

enum StepStatus { completed, inProgress, pending }

class TrackingOrderMaps extends StatefulWidget {
  const TrackingOrderMaps({super.key});

  @override
  State<TrackingOrderMaps> createState() => TrackingOrderMapsState();
}

class TrackingOrderMapsState extends State<TrackingOrderMaps> {
  String? userUID;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
    userUID = FirebaseAuth.instance.currentUser?.uid;
    print("✅ User uid: $userUID");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingOrderMapLogic, TrackingOrderMapState>(
      builder: (context, state) {
        final objTracking = context.watch<TrackingOrderMapLogic>();
        return isLoading
            ? Center(child: CircularProgressIndicator(color: AppColors.primary))
            : Scaffold(
                body: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: objTracking.userPosition != null
                            ? LatLng(
                                objTracking.userPosition!.latitude,
                                objTracking.userPosition!.longitude,
                              )
                            : const LatLng(30.05, 31.31),
                        zoom: 17.5,
                      ),
                      markers: objTracking.driverMarkers,
                      polylines: {
                        Polyline(
                          polylineId: PolylineId("Saree3 App 🏍️"),
                          points: objTracking.polyPoints,
                          width: 4,
                          color: Colors.red,
                        ),
                      },
                      myLocationEnabled: objTracking.userPosition != null,
                      myLocationButtonEnabled: false,
                      onMapCreated: (controller) {
                        context.read<TrackingOrderMapLogic>().setMapController(
                          controller,
                        );
                      },
                    ),
                    _customBottomSheet(objTracking: objTracking),
                  ],
                ),
              );
      },
    );
  }

  Widget _customBottomSheet({required TrackingOrderMapLogic objTracking}) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.25,
      maxChildSize: 0.75,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
            ],
          ),
          padding: EdgeInsets.only(right: 20.w, left: 20.w),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  height: 5.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Gap(20.h),

              // بيانات المطعم
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 70.h,
                      height: 70.w,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.restaurant, color: Colors.grey),
                    ),
                  ),
                  Gap(15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Uttora Coffee House",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Ordered At 06 Sept, 10:00pm",
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              // Gap(15.h),
              Padding(
                padding: EdgeInsets.only(left: 85.w),
                child: Text(
                  "2x Burger\n4x Sandwich",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
                ),
              ),

              Gap(25.h),
              Text(
                objTracking.etaText,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "ESTIMATED DELIVERY TIME",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              Gap(25.h),

              // الـ progress steps
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep(
                    "Your order has been received",
                    StepStatus.completed,
                    false,
                  ),
                  _buildStep(
                    "The restaurant is preparing your food",
                    StepStatus.inProgress,
                    false,
                  ),
                  _buildStep(
                    "Your order has been picked up for delivery",
                    StepStatus.pending,
                    false,
                  ),
                  _buildStep("Order arriving soon!", StepStatus.pending, true),
                ],
              ),

              Gap(50.h),

              // بيانات الكابتن
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/saree3-6a6dc.firebasestorage.app/o/Profile%20User%2FMoaz%20B-Badla.jpg?alt=media&token=08dcf6fd-79ca-4739-8984-0cebd115a583",
                    ), // صورة افتراضية
                  ),
                  Gap(15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        objTracking.driverName!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   "Courier",
                      //   style: TextStyle(
                      //     fontSize: 12.sp,
                      //     color: AppColors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      onPressed: () {
                        _makePhoneCall(phoneNumber: objTracking.driverPhone!);
                      },
                      icon: Icon(Icons.call, color: AppColors.white),
                    ),
                  ),
                  Gap(10.w),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.message, color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _makePhoneCall({required String phoneNumber}) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Widget _buildStep(String text, StepStatus status, bool isLast) {
    Color activeColor = Color(0xff8C0700);
    Color inactiveColor = Colors.grey.shade300;

    Widget iconWidget;

    if (status == StepStatus.completed) {
      // ✅ مكتمل
      iconWidget = Icon(Icons.check, size: 12.sp, color: Colors.white);
    } else if (status == StepStatus.inProgress) {
      // ⏳ جاري التنفيذ → loader
      iconWidget = SizedBox(
        width: 9.w,
        height: 9.h,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      // ⭕ لسه ما اشتغلش
      iconWidget = Icon(Icons.circle, size: 8.sp, color: inactiveColor);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // الأيقونة جوا الدايرة
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: status == StepStatus.inProgress
                    ? activeColor
                    : (status == StepStatus.completed
                          ? activeColor
                          : inactiveColor),
              ),
              child: iconWidget,
            ),

            // الخط النازل (لو مش آخر واحد)
            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color:
                    status == StepStatus.completed ||
                        status == StepStatus.inProgress
                    ? activeColor
                    : inactiveColor,
              ),
          ],
        ),
        Gap(10.w),

        // النص
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              text,
              style: TextStyle(
                color: status == StepStatus.inProgress
                    ? Colors.grey
                    : (status == StepStatus.completed
                          ? Color(0xff8C0700)
                          : Colors.grey),
                fontWeight:
                    status == StepStatus.inProgress ||
                        status == StepStatus.completed
                    ? FontWeight.w900
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
      





  /*

  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (objTracking.etaText != null && objTracking.routeKm != null) ...[
        Text(
          "🚴‍♂️ السواق في الطريق",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(8.h),
        Text(
          "المسافة: ${objTracking.routeKm!.toStringAsFixed(1)} كم",
          style: TextStyle(fontSize: 14.sp),
        ),
        Text(
          "الوقت المتوقع: ${objTracking.etaText}",
          style: TextStyle(fontSize: 14.sp, color: Colors.green),
        ),
      ] else ...[
        Center(child: CircularProgressIndicator()),
      ],
    ],
  ),

  */