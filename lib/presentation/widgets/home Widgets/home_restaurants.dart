import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../model/restaurant/restaurant_model.dart';
import '../../screens/homePage/restaurant_detail_page.dart';
import 'restaurant_card.dart';


  Widget homeRestaurants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Gap( 10.h),
        Text(
          'Open Restaurants',
          style:  TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        // Restaurants List
        Restaurant.restaurantsByCategory.isEmpty
            ?  SizedBox(
                height: 200.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu, size: 60.sp, color: Colors.grey),
                      Gap( 16.h),
                      Text(
                        'No restaurants found',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Restaurant.restaurantsByCategory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:  EdgeInsets.only(bottom: 16.h),
                      child: RestaurantCard(
                        restaurant: Restaurant.restaurantsByCategory[index],
                        onTap: () {
                          // Navigate to restaurant detail page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailPage(
                                restaurant:
                                    Restaurant.restaurantsByCategory[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
