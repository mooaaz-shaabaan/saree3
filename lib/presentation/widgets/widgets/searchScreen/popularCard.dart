import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../model/popularFoodModel.dart';

Widget popularCard(PopularFood data) {
  return SizedBox(
    width: 210.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFB7C0C8),
              borderRadius: BorderRadius.circular(16.r),
            ),
            width: double.infinity,
          ),
        ),
        Gap(8.h),
        Container(
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12).r,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6.r),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Gap(4.h),
              Text(
                data.subtitle,
                style:  TextStyle(fontSize: 12.sp, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
