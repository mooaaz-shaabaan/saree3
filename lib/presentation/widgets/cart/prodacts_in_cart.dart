import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../bussines_logic/cart/cart_logic.dart';

Widget prodactsInCart(CartLogic cubit) {
  return ListView.builder(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    itemCount: cubit.cartItems.length,
    itemBuilder: (context, index) {
      final item = cubit.cartItems[index];
      return Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image Placeholder
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),

                child: Image.network(
                  item.imageProdact,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 40.sp,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            Gap(15.w),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Gap(5.w),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                  Gap(5.w),
                  Text(
                    'Qty: ${item.quantity}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            // Status and Remove Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'DONE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(10.h),
                GestureDetector(
                  onTap: () => cubit.removeItem(item.id),
                  child: Container(
                    padding: EdgeInsets.all(4.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
