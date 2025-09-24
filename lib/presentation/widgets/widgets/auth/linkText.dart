import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget linkText({
  required String text,
  required VoidCallback onPressed,
  Color color = Colors.orange,
}) => GestureDetector(
  onTap: onPressed,
  child: Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    ),
  ),
);
