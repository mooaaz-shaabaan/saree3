import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../screens/homePage/food_detail_page.dart';
import 'menu_item_card.dart';
import '../../../../constants/constants.dart';

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
