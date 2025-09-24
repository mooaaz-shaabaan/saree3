import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/constants.dart';

Widget customTextButton({required String text}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 15.sp,
      color: AppColors.background,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w900,
    ),
  );
}
