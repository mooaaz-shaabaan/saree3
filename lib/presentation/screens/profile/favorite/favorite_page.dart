import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../bussines_logic/favorite/favorite_cubit.dart';
import '../../../../constants/constants.dart';
import '../../../widgets/widgets/restaurant doc/menu_item_card.dart';
import '../../homePage/food_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteLogic, FavoriteState>(
      builder: (context, state) {
        FavoriteLogic addRemove = context
            .read<FavoriteLogic>();
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: 40.h, right: 16.w, left: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6.r,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.arrow_back_ios_new, size: 16.sp),
                      ),
                    ),
                    Gap(12.w),
                    Text(
                      'Favourite',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                addRemove.favorites.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "The Favourite Is Empty",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 18.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingM,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: .7,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                          itemCount: addRemove.favorites.length,
                          itemBuilder: (context, index) {
                            final menuItem = addRemove.favorites[index];
                            return menuItemCard(
                              menuItem: menuItem,
                              context: context,
                              index: index,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FoodDetailPage(
                                      menuItem: menuItem,
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
