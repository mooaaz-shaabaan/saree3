import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../bussines_logic/data_user/data_user_cubit.dart';
import '../../widgets/home Widgets/home_greeting.dart';
import '../../widgets/home Widgets/home_restaurants.dart';
import '../../widgets/home Widgets/home_search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<DataUserLogic>().getData;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Padding(
          padding: EdgeInsets.only(top: 50.h, right: 16.w, left: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                homeGreeting(context: context),
                Gap(20.h),
                homeSearchBar(context: context),
                Gap(30.h),
                // HomeCategories(),
                // Gap(30.h),
                homeRestaurants(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
