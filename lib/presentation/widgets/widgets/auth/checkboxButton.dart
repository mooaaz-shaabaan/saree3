import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Widget checkboxButton({
  required bool value,
  required ValueChanged<bool> onChanged,
  String label = "Remember me",
  Color activeColor = Colors.teal,
  Color? checkColor,
}) => InkWell(
  onTap: () => onChanged(!value),
  borderRadius: BorderRadius.circular(8.r),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        value: value,
        onChanged: (v) => onChanged(v ?? false),
        activeColor: activeColor,
        checkColor: checkColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      Gap(6.w),
      Text(label, style: TextStyle(fontSize: 14.sp)),
    ],
  ),
);
