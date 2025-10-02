import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saree3/bussines_logic/user_maps/user_maps_cubit.dart';
import 'package:saree3/bussines_logic/user_maps/user_maps_state.dart';

class UserMaps extends StatefulWidget {
  const UserMaps({super.key});

  @override
  State<UserMaps> createState() => UserMapsState();
}

class UserMapsState extends State<UserMaps> {
  String? userUID;

  @override
  void initState() {
    super.initState();
    userUID = FirebaseAuth.instance.currentUser?.uid;
    print("✅ User UID: $userUID");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserMapsLogic, UserMapsStatee>(
      builder: (context, state) {
        final objUserMaps = context.watch<UserMapsLogic>();
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                myLocationEnabled: objUserMaps.userPosition != null,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: objUserMaps.userPosition != null
                      ? LatLng(
                          objUserMaps.userPosition!.latitude,
                          objUserMaps.userPosition!.longitude,
                        )
                      : const LatLng(30.05, 31.31),
                  zoom: 15,
                ),
                markers: objUserMaps.driverMarkers,
                onMapCreated: (controller) {
                  context.read<UserMapsLogic>().setMapController(controller);
                },
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(
                            Icons.location_history,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                          onPressed: () => objUserMaps.moveToUserPosition(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // _customBottomSheet(),
            ],
          ),
        );
      },
    );
  }

  // Widget _customBottomSheet() {
  //   return DraggableScrollableSheet(
  //     initialChildSize: 0.2.h,
  //     minChildSize: 0.2.h,
  //     maxChildSize: 0.2.h,
  //     builder: (context, controller) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
  //           boxShadow: [
  //             BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
  //           ],
  //         ),
  //         padding: EdgeInsets.only(right: 20, left: 20, top: 0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Gap(20),
  //             Center(
  //               child: InkWell(
  //                 onTap: () {
  //                   // _upTpFirestore();
  //                 },
  //                 child: Container(
  //                   height: 5,
  //                   width: 50,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[300],
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 20),

  //             // بيانات المطعم
  //             Row(
  //               children: [
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(10),
  //                   child: Container(
  //                     width: 70.h,
  //                     height: 70.w,
  //                     color: Colors.grey.shade300,
  //                     child: Icon(Icons.restaurant, color: Colors.grey),
  //                   ),
  //                 ),
  //                 Gap(15.w),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "Uttora Coffee House",
  //                       style: TextStyle(
  //                         fontSize: 16.sp,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     Text(
  //                       "Ordered At 06 Sept, 10:00pm",
  //                       style: TextStyle(fontSize: 12, color: Colors.grey),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),

  //             // SizedBox(height: 15),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 85),
  //               child: Text(
  //                 "2x Burger\n4x Sandwich",
  //                 style: TextStyle(fontSize: 14, color: Colors.grey[800]),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
  