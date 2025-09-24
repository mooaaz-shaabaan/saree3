import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../model/restaurant/restaurant_rating.dart';

Widget restaurantTile(RestaurantRating item) {
    return ListTile(
      contentPadding:  EdgeInsets.symmetric(vertical: 6.h),
      leading: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFFB7C0C8),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
           Icon(Icons.star_border, size: 16.sp, color: Colors.redAccent),
          Gap(6.w),
          Text(
            item.rating.toString(),
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
      onTap: () {},
    );
  }
