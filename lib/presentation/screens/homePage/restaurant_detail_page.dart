import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:saree3/services/api_proudct_services.dart';
import '../../../constants/constants.dart';
import '../../../model/prodact_model.dart';
import '../../../model/restaurant/restaurant_model.dart';
import '../../widgets/restaurant doc/header.dart';
import '../../widgets/restaurant doc/image.dart';
import '../../widgets/restaurant doc/menu_item.dart';
import '../../widgets/restaurant doc/restaurant_doc.dart';

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder(
        future: ApiServices().prodacts(resturantName: restaurant.resturantName),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MenuItem> prodacts = snapshot.data!;
            return SafeArea(
              child: Column(
                children: [
                  Header(context: context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageReasurant(restaurant: restaurant),
                          Gap(AppSizes.spacingL),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingM,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RestaurantDoc(restaurant: restaurant),

                                Gap(AppSizes.spacingL),
                                Text(
                                  'Menu',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                ),
                                Gap(AppSizes.spacingL),
                              ],
                            ),
                          ),
                          menuItemGrid(
                            context: context,
                            itemCount: prodacts.length,
                            items: prodacts,
                          ),
                          Gap(AppSizes.spacingXL),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("Faild is data ===> ${snapshot.error}"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
