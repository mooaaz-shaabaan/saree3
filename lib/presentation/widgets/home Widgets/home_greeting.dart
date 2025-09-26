import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saree3/constants/constants.dart';

import '../../../bussines_logic/data_user/data_user_cubit.dart';

Widget homeGreeting({required BuildContext context}) {
  return BlocBuilder<DataUserLogic, DataUserState>(
    builder: (context, state) {
      final data = context.watch<DataUserLogic>();
      String fullName = data.fullName;
      String firstName = fullName.isNotEmpty
          ? fullName.split(" ").first
          : "Dear";
      return Row(
        spacing: 15.w,
        children: [
          // CircleAvatar(
          //   radius: 25.r,
          //   backgroundColor: AppColors.primary,
          //   backgroundImage: NetworkImage(data.image),
          // ),
          ClipOval(
            child: Image.network(
              data.image,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return CircleAvatar(
                  radius: 25.r,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 25, color: Colors.white),
                );
              },
            ),
          ),

          Text(
            'Hey $firstName, Good Afternoon!',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      );
    },
  );
}
