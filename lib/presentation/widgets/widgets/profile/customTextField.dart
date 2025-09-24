import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customTextField(
  TextEditingController controller, {
  String? hint,
  Color? fillColor,
  int maxLines = 1,
}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12.r),
      ),
    ),
  );
}
