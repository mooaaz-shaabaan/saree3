import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:saree3/constants/constants.dart';

import '../../../bussines_logic/data_user/data_user_cubit.dart';
import '../../widgets/home Widgets/home_greeting.dart';
import '../../widgets/home Widgets/home_restaurants.dart';
import '../../widgets/home Widgets/home_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<DataUserLogic>().getData();
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : GestureDetector(
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
                        homeRestaurants(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<bool> checkLocationPermission() async {
    // 1️⃣ التأكد من تفعيل خدمة الموقع
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false;
    }

    // 2️⃣ التحقق من صلاحية الوصول للموقع
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    // ✅ لو كل حاجة تمام
    return true;
  }
}
