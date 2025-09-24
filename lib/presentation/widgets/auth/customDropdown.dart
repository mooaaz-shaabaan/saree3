import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customDropdown<T>({
  required T? value,
  required List<T> items,
  required String hint,
  required Function(T?) onChanged,
  required Color color,
  required double radius,
  String? Function(T?)? validator,
}) => DropdownButtonFormField<T>(
  value: value,
  isExpanded: true,
  decoration: InputDecoration(
    labelText: hint.toUpperCase(),
    labelStyle:  TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black54,
    ),
    filled: true,
    fillColor: color, // same as LoginTextField / PasswordTextField
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
        item.toString(),
        style:  TextStyle(fontSize: 16.sp, color: Colors.black87),
      ),
    );
  }).toList(),
  onChanged: onChanged,
  validator: validator,
);
