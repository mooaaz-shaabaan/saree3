import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../bussines_logic/cart/cart_logic.dart';
import '../../../bussines_logic/favorite/favorite_cubit.dart';
import '../../../constants/constants.dart';
import '../../../model/prodact_model.dart';

class FoodDetailPage extends StatelessWidget {
  final MenuItem menuItem;
  final int index;

  FoodDetailPage({super.key, required this.menuItem, required this.index});

  final List<Map<String, dynamic>> ingredients = [
    {"icon": Icons.local_drink, "name": "Drink", "color": Color(0xFFFFE5CC)},
    {"icon": Icons.restaurant, "name": "Sauce", "color": Color(0xFFFFE5CC)},
    {"icon": Icons.eco, "name": "Herbs", "color": Color(0xFFFFE5CC)},
    {"icon": Icons.warning, "name": "Spicy", "color": Color(0xFFFFE5CC)},
    {"icon": Icons.no_meals, "name": "No Dairy", "color": Color(0xFFFFE5CC)},
  ];

  @override
  Widget build(BuildContext context) {
    final Cart = context.read<FavoriteLogic>();
    final int quantity = Cart.getQuantity(menuItem);
    final double currentPrice = menuItem.price * quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with image
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  // Food image
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(16.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
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
                  // Header buttons
                  Positioned(
                    top: 30,
                    left: 30,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  BlocBuilder<FavoriteLogic, FavoriteState>(
                    builder: (context, state) {
                      final Cart = context.read<FavoriteLogic>();
                      bool isFavorite = Cart.isFavoriteItem(menuItem);

                      return Positioned(
                        top: 30,
                        right: 30,
                        child: GestureDetector(
                          onTap: () {
                            Cart.toggleFavorite(menuItem, context);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: isFavorite ? Colors.red : Colors.black54,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom sheet with details
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food name and location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menuItem.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Gap(4.h),
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Color(0xFF8C0700),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Rose Garden',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF8C0700),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Gap(16.h),

                      // Rating and delivery info
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Color(0xFF8C0700),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '4.7',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.delivery_dining,
                            size: 18,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Free',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '20 min',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),

                      Gap(16.h),

                      // Description
                      Text(
                        menuItem.description.isNotEmpty
                            ? menuItem.description
                            : 'Maecenas sed diam eget risus varius blandit sit amet non magna. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),

                      Gap(20.h),

                      // Ingredients
                      const Text(
                        'INGREDIENTS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Gap(12.h),
                      Row(
                        children: ingredients.map((ingredient) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: ingredient['color'],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                ingredient['icon'],
                                size: 24,
                                color: const Color(0xFF8C0700),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const Spacer(),

                      // Price and add to cart
                      Row(
                        children: [
                          // Price
                          Text(
                            '\$${currentPrice.toInt()}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const Spacer(),

                          // Quantity selector
                          BlocBuilder<FavoriteLogic, FavoriteState>(
                            builder: (context, state) {
                              final plusMins = context.read<FavoriteLogic>();
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        plusMins.minsQuantity(menuItem);
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        plusMins
                                            .getQuantity(menuItem)
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        plusMins.plusQuantity(menuItem);
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      Gap(20.h),

                      // Add to cart button
                      BlocBuilder<FavoriteLogic, FavoriteState>(
                        builder: (context, state) {
                          final plusMins = context.read<FavoriteLogic>();
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                addToCart(
                                  context: context,
                                  menuItem: menuItem,
                                  quantity: plusMins.getQuantity(menuItem),
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'ADD TO CART',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void addToCart({
  required BuildContext context,
  required MenuItem menuItem,
  required int quantity,
}) {
  final result = context.read<CartLogic>().addMenuItemToCart(menuItem);

  if (result == AddToCartResult.differentRestaurant) {
    // لو المنتج من مطعم مختلف نطلع Dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تنبيه"),
        content: Text("مش هتقدر تتطلب من أكتر من مطعم في نفس الوقت."),
        actions: [
          TextButton(
            onPressed: () {
              context.read<CartLogic>().clearCart();
              context.read<CartLogic>().addMenuItemToCart(menuItem);
              Navigator.pop(context);
            },
            child: Text("تفريغ السلة"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء"),
          ),
        ],
      ),
    );
  } else {
    // لو اتضاف المنتج بنجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menuItem.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
