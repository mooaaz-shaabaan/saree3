import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:saree3/model/prodact_model.dart';
import '../../../../bussines_logic/cart/cart_logic.dart';
import '../../../../constants/constants.dart';
import '../../../../model/card_item.dart';
import '../../../screens/homePage/food_detail_page.dart';

Widget menuItemCard({
  required BuildContext context,
  required MenuItem menuItem,
  required Function() onTap,
  required int index,
}) {
  return GestureDetector(
    onTap: () {
      // Navigate to food detail page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FoodDetailPage(menuItem: menuItem, index: index),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: AppSizes.spacingM,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu Item Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusS),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusS),
                ),
                child: Image.network(
                  menuItem.imageProdact,
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
          ),

          // Menu Item Info
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(AppSizes.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuItem.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(AppSizes.spacingXS),
                      Text(
                        menuItem.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // Price and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${menuItem.price.toInt()}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Add to cart functionality
                          context.read<CartLogic>().addToCart(
                            CartItem(
                              id: menuItem.id,
                              name: menuItem.name,
                              price: menuItem.price,
                              quantity: 1,
                              description: menuItem.description,
                              imageProdact: menuItem.imageProdact,
                              imageResturant: menuItem.imageResturant,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${menuItem.name} added to cart'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          width: AppSizes.iconM,
                          height: AppSizes.iconM,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: AppSizes.iconS,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
