import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customButton({
  required String text,
  required VoidCallback onPressed,
  required Color color,
  required double radius,
  required double height,
  required double width,
}) => ElevatedButton(
  onPressed: onPressed,
  style: ElevatedButton.styleFrom(
    backgroundColor: color,
    minimumSize: Size(width.w, height.h),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.r)),
  ),
  child: Text(
    text.toUpperCase(),
    style:  TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);
