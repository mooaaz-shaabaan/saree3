import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Widget customTextFormField({
  required String hintText,
  required TextEditingController controller,
  required String? Function(String?)? validator,
  Icon? icon,
  required String label,
  Function()? onPressed,
  bool password = false,
  bool obscureText = false,
}) => Column(
  children: [
    Align(alignment: Alignment.centerLeft, child: Text(label)),
    Gap(10.h),
    TextFormField(
      obscureText: obscureText,
      validator: validator,
      controller: controller,

      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        suffixIcon: password
            ? IconButton(
                onPressed: onPressed,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
        hintText: hintText,
        labelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
        prefixIcon: icon,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  ],
);
