import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget homeGreeting({required BuildContext context}) {
  return Row(
    spacing: 15.w,
    children: [
      CircleAvatar(
        radius: 25.r,
        backgroundImage: AssetImage('assets/images/user_avatar.png'),
      ),
      Text(
        'Hey Halal, Good Afternoon!',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    ],
  );
}
