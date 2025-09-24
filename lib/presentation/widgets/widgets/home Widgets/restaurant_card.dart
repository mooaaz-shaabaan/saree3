import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../model/restaurant/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            _buildRestaurantImage(),

            // Restaurant Info
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    restaurant.cuisine,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                  Gap(12.h),
                  _buildRestaurantDetails(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantImage() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: restaurant.imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                restaurant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
              ),
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(Icons.restaurant, size: 40.sp, color: Colors.grey),
    );
  }

  Widget _buildRestaurantDetails() {
    return Row(
      children: [
        Icon(Icons.star, size: 16.sp, color: Color(0xFF8C0700)),
        Gap(4.w),
        Text(
          restaurant.rating,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        Gap(16.w),
        Icon(
          Icons.delivery_dining,
          size: 16.sp,
          color: restaurant.deliveryInfo == 'Free'
              ? Colors.green
              : Colors.orange,
        ),
        Gap(4.w),
        Text(
          restaurant.deliveryInfo,
          style: TextStyle(
            fontSize: 14.sp,
            color: restaurant.deliveryInfo == 'Free'
                ? Colors.green
                : Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(16.w),
        Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
        Gap(4.w),
        Text(
          restaurant.deliveryTime,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      ],
    );
  }
}
