import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget keywordChip(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8).h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
  );
}
