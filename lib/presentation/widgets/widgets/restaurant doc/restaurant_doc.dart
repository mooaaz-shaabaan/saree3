import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../constants/constants.dart';
import '../../../../model/restaurant/restaurant_model.dart';


class RestaurantDoc extends StatelessWidget {
  const RestaurantDoc({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        Gap(AppSizes.spacingS),
        Text(
          'Maecenas sed diam eget risus varius blandit sit amet non magna. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.grey.withOpacity(0.7),
            height: 1.4.h,
          ),
        ),
        Gap(AppSizes.spacingL),
        Row(
          children: [
            Icon(Icons.star, size: AppSizes.iconS, color: AppColors.primary),
            Gap(AppSizes.spacingXS),
            Text(
              restaurant.rating,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            Gap(AppSizes.spacingXL),
            Icon(
              Icons.delivery_dining,
              size: AppSizes.iconS,
              color: restaurant.deliveryInfo == 'Free'
                  ? AppColors.green
                  : AppColors.orange,
            ),
            Gap(AppSizes.spacingXS),
            Text(
              restaurant.deliveryInfo,
              style: TextStyle(
                fontSize: 16.sp,
                color: restaurant.deliveryInfo == 'Free'
                    ? AppColors.green
                    : AppColors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(AppSizes.spacingXL),
            Icon(
              Icons.access_time,
              size: AppSizes.iconS,
              color: AppColors.grey,
            ),
            Gap(AppSizes.spacingXS),
            Text(
              restaurant.deliveryTime,
              style: TextStyle(fontSize: 16.sp, color: AppColors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
