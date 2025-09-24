import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Widget buildTopRow(BuildContext context) {
  return Row(
    children: [
      GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F3F4),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Icon(Icons.chevron_left, color: Colors.black54),
        ),
      ),
     Gap(12.w),
       Text(
        'Search',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
      ),
      const Spacer(),
      Stack(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFF0D2436),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child:  Text(
                '2',
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
