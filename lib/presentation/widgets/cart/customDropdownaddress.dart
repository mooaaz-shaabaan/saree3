

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Widget customDropdownAddresses<T>({
  required T? value,
  required List<T> items,
  required String label,
  required Function(T?) onChanged,
  required Color color,
  required double radius,
  String? Function(T?)? validator,
  required String Function(T) itemLabel, // هنا بنحدد النص اللي هيتعرض
}) => Column(
  children: [
    Align(alignment: Alignment.centerLeft, child: Text(label.toUpperCase())),
    Gap(10.h),
    DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
        filled: true,
        fillColor: color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: color,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel(item), // هنا بنستخدم الفنكشن
            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    ),
  ],
);
