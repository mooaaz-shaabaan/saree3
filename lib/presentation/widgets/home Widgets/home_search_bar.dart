import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget homeSearchBar({required BuildContext context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8.r,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextField(
      // enabled: false,
      decoration: const InputDecoration(
        hintText: 'Search restaurants',
        border: InputBorder.none,
        icon: Icon(Icons.search, color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
  );
}
