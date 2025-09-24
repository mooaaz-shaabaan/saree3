import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:saree3/bussines_logic/address/address_cubit.dart';
import 'package:saree3/bussines_logic/address/address_state.dart';
import 'package:saree3/presentation/screens/profile/address/add_address.dart';
import '../../../bussines_logic/cart/cart_logic.dart';
import '../../../constants/constants.dart';
import '../../widgets/cart/customDropdownaddress.dart';
import '../../widgets/cart/prodacts_in_cart.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  CartPage({super.key});
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartLogic, CartState>(
      builder: (context, state) {
        CartLogic cubit = context.read<CartLogic>();
        return Scaffold(
          backgroundColor: Colors.grey[50],

          body: Column(
            children: [
              Gap(60.h),

              // Cart Items Section
              Expanded(
                child: cubit.cartItems.isEmpty
                    ? Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16.sp,
                          ),
                        ),
                      )
                    : prodactsInCart(cubit),
              ),
              // Bottom Section
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Delivery Address Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DELIVERY ADDRESS',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => AddAddressPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Add New Address',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(10.h),
                    BlocBuilder<AddressLogic, AddressState>(
                      builder: (context, state) {
                        final addressLogic = context.read<AddressLogic>();

                        // لو العناوين فاضية
                        if (addressLogic.addresses.isEmpty) {
                          return Center(
                            child: const Text(
                              "Addresses is Empty",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }

                        // لو فيه عناوين
                        return Column(
                          children: [
                            customDropdownAddresses<String>(
                              color: AppColors.background,
                              radius: AppSizes.buttonRadius,
                              value: addressLogic
                                  .addresses[addressLogic.isSelected]
                                  .id,
                              items: addressLogic.addresses
                                  .map((e) => e.id)
                                  .toList(),
                              label: "Address",
                              itemLabel: (id) {
                                final a = addressLogic.addresses.firstWhere(
                                  (a) => a.id == id,
                                );
                                return '${a.type} , ${a.address}';
                              },
                              onChanged: (val) {
                                if (val != null) {
                                  addressLogic.updateAddress(val);
                                }
                              },
                            ),
                            Gap(20.h),
                          ],
                        );
                      },
                    ),

                    // Total Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Gap(5.h),
                    BlocBuilder<CartLogic, CartState>(
                      builder: (context, state) {
                        double total = context.read<CartLogic>().totalAmount;
                        return Text(
                          '${total.toStringAsFixed(0)} EGP',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                    Gap(20.h),

                    // Place Order Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed:
                            context.watch<CartLogic>().cartItems.isEmpty ||
                                context.watch<AddressLogic>().addresses.isEmpty
                            ? null
                            : () {
                                // Handle place order
                                _upTpFirestore(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8B0000), // Dark red color
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'PLACE ORDER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _upTpFirestore(BuildContext context) async {
    var cartItems = context.read<CartLogic>();
    var address = context.read<AddressLogic>();
    double total = context.read<CartLogic>().totalAmount;
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userUID': userUID,
        'latitude': address.addressSelectedLat,
        'longitude': address.addressSelectedLng,
        'restaurantName': cartItems.cartItems.first.restaurantName,
        'restaurantNameDefault':
            cartItems.cartItems.first.restaurantNameDefault,
        'imageResturant': cartItems.cartItems.first.imageResturant,
        'status': "pending",
        'Total Price': total.toStringAsFixed(0),
        'cartItems': cartItems.cartItems.map((item) => item.toMap()).toList(),
        'time': DateTime.now(),
      });
      _placeOrder(context);
      cartItems.clearCart();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: "Error , Please Try Agin",
      ).show();
    }
  }

  void _placeOrder(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: "Done",
    ).show();
  }
}
