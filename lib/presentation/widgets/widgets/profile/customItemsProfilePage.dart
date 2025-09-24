import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../screens/profile/profile_page.dart';

Widget customItemProfilePage({required List menuItems}) {
  return Column(
    children: List.generate(menuItems.length, (i) {
      ProfileItems item = menuItems[i];

      return Column(
        children: [
          InkWell(
            onTap: () => item.onTap,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 8.h,
              ),
              leading: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color, size: 22.sp),
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16.sp,
              ),
              onTap: item.onTap,
            ),
          ),
          if (i != menuItems.length - 1)
            Divider(
              height: 1.h,
              thickness: 1.sp,
              color: Colors.grey[100],
              indent: 80,
            ),
        ],
      );
    }),
  );
}

