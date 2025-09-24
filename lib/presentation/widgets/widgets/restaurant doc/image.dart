import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/constants.dart';
import '../../../../model/restaurant/restaurant_model.dart';

Widget imageReasurant({required Restaurant restaurant}) {
  return Container(
    height: AppSizes.restaurantImageHeight,
    margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
    decoration: BoxDecoration(
      color: AppColors.grey,
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
    ),
    child: Center(
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(AppSizes.paddingM),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.network(
            restaurant.imageUrl,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return _buildImagePlaceholder();
            },
          ),
        ),
      ),
    ),
  );
}

Widget _buildImagePlaceholder() {
  return Center(
    child: Icon(Icons.restaurant, size: 40.sp, color: Colors.grey),
  );
}
