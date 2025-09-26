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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
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
        final objTracking = context.read<TrackingOrderMapLogic>();
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
      minChildSize: 0.1,
      maxChildSize: 0.7,
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

              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 70.h,
                      height: 70.w,
                      color: Colors.grey.shade300,
                      child: Image.network(
                        objTracking.cartItems![0].imageResturant,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Gap(15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Abo Tark",
                        // objTracking.cartItems![0].restaurantName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "1500 EGP",
                        // objTracking.totalPrice,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      _showDetalseDialog(
                        context: context,
                        objTracking: objTracking,
                      );
                    },
                    child: Text(
                      "Show Details Order..!",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
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

              if (objTracking.driverName != null &&
                  objTracking.driverPhone != null) ...[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(Images.firstImageProfile),
                    ),
                    Gap(15.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          objTracking.driverName ?? "Delivery Captain",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        onPressed: () {
                          if (objTracking.driverPhone != null) {
                            _makePhoneCall(
                              phoneNumber: objTracking.driverPhone!,
                            );
                          }
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
              ] else ...[
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.delivery_dining, color: Colors.grey),
                      Gap(15.w),
                      Text(
                        "Assigning the delivery captain... 🚴",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  void _showDetalseDialog({
    required BuildContext context,
    required TrackingOrderMapLogic objTracking,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Order Items"),
          content: SizedBox(
            width: double.maxFinite,
            height: 500.h,
            child: ListView.builder(
              itemCount: objTracking.cartItems!.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: objTracking.cartItems!.length,
                      itemBuilder: (context, itemIndex) {
                        final item = objTracking.cartItems![itemIndex];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.imageProdact,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Gap(12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("Quantity: ${item.quantity}"),
                                    Text(
                                      "${item.price} EGP",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(
                                item.restaurantNameDefault,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStep(String text, StepStatus status, bool isLast) {
    Color activeColor = Color(0xff8C0700);
    Color inactiveColor = Colors.grey.shade300;

    Widget iconWidget;

    if (status == StepStatus.completed) {
      iconWidget = Icon(Icons.check, size: 12.sp, color: Colors.white);
    } else if (status == StepStatus.inProgress) {
      iconWidget = SizedBox(
        width: 9.w,
        height: 9.h,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      iconWidget = Icon(Icons.circle, size: 8.sp, color: inactiveColor);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
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

  Widget buildStepNew({
    required String text,
    required TrackingOrderMapLogic objStatus,
    required bool isLast,
  }) {
    Color activeColor = Color(0xff8C0700);
    Color inactiveColor = Colors.grey.shade300;

    Widget iconWidget;

    if (objStatus.statusOrder == "completed") {
      iconWidget = Icon(Icons.check, size: 12.sp, color: Colors.white);
    } else if (objStatus.statusOrder == "inProgress") {
      iconWidget = SizedBox(
        width: 9.w,
        height: 9.h,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      iconWidget = Icon(Icons.circle, size: 8.sp, color: inactiveColor);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: objStatus.statusOrder == "inProgress"
                    ? activeColor
                    : (objStatus.statusOrder == "completed"
                          ? activeColor
                          : inactiveColor),
              ),
              child: iconWidget,
            ),

            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color:
                    objStatus.statusOrder == "completed" ||
                        objStatus.statusOrder == "inProgress"
                    ? activeColor
                    : inactiveColor,
              ),
          ],
        ),
        Gap(10.w),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              text,
              style: TextStyle(
                color: objStatus.statusOrder == "inProgress"
                    ? Colors.grey
                    : (objStatus.statusOrder == "completed"
                          ? Color(0xff8C0700)
                          : Colors.grey),
                fontWeight:
                    objStatus.statusOrder == "inProgress" ||
                        objStatus.statusOrder == "completed"
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
