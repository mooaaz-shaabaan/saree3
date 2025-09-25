import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../bussines_logic/cart/cart_logic.dart';
import '../../../model/prodact_model.dart';
import '../../screens/homePage/food_detail_page.dart';
import '../../../constants/constants.dart';

Widget menuItemGrid({
  required BuildContext context,
  required int itemCount,
  required List items,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .7.w,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final menuItem = items[index];
        return menuItemCard(
          menuItem: menuItem,
          context: context,
          index: index,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FoodDetailPage(menuItem: menuItem, index: index),
              ),
            );
          },
        );
      },
    ),
  );
}

Widget menuItemCard({
  required BuildContext context,
  required MenuItem menuItem,
  required Function() onTap,
  required int index,
}) {
  return GestureDetector(
    onTap: onTap,
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
                        '${menuItem.price.toInt()} EGP',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final result = context
                              .read<CartLogic>()
                              .addMenuItemToCart(menuItem);

                          if (result == AddToCartResult.differentRestaurant) {
                            // لو المنتج من مطعم مختلف نطلع Dialog
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.bottomSlide,
                              title:
                                  "You can't order from more than one restaurant at the same time.",
                              btnCancelOnPress: () {
                                Navigator.pop(context);
                              },
                              btnCancelText: "Cancel",
                              btnOkOnPress: () {
                                context.read<CartLogic>().clearCart();
                                context.read<CartLogic>().addMenuItemToCart(
                                  menuItem,
                                );
                              },
                              btnOkText: "Clear Cart",
                            ).show();

                            // showDialog(
                            //   context: context,
                            //   builder: (context) => AlertDialog(
                            //     title: Text("تنبيه"),
                            //     content: Text(
                            //       "مش هتقدر تتطلب من أكتر من مطعم في نفس الوقت.",
                            //     ),
                            //     actions: [
                            //       TextButton(
                            //         onPressed: () {
                            //           context.read<CartLogic>().clearCart();
                            //           context
                            //               .read<CartLogic>()
                            //               .addMenuItemToCart(menuItem);
                            //           Navigator.pop(context);
                            //         },
                            //         child: Text("تفريغ السلة"),
                            //       ),
                            //       TextButton(
                            //         onPressed: () => Navigator.pop(context),
                            //         child: Text("إلغاء"),
                            //       ),
                            //     ],
                            //   ),
                            // );
                          } else {
                            // لو اتضاف المنتج بنجاح
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${menuItem.name} added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
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
