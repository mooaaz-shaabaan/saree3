import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:saree3/presentation/screens/profile/address/add_address.dart';
import '../../../../bussines_logic/address/address_cubit.dart';
import '../../../../bussines_logic/address/address_state.dart';
import '../../../../constants/constants.dart';
import '../../../widgets/profile/customTextButton.dart';
import 'edit_address.dart';

class MyAddressPage extends StatelessWidget {
  const MyAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    'My Address',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Gap(24.h),
              // List
              context.watch<AddressLogic>().addresses.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    )
                  : viewAddress(),
              // Add button
              addNewAddress(context),
              Gap(2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget addNewAddress(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => AddAddressPage()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 6,
        ),
        child: customTextButton(text: 'ADD NEW ADDRESS'),
      ),
    );
  }

  Widget viewAddress() {
    return Expanded(
      child: BlocBuilder<AddressLogic, AddressState>(
        builder: (context, state) {
          AddressLogic addressLogic = context.read<AddressLogic>();
          return ListView.builder(
            itemCount: addressLogic.addresses.length,
            itemBuilder: (context, index) {
              final item = addressLogic.addresses[index];
              return Container(
                margin: EdgeInsets.only(bottom: 14.h),
                padding: EdgeInsets.all(14.h),
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: item.color),
                    ),
                    Gap(12.w),

                    // Address text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.type,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            item.address,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Edit + Delete
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) =>
                              EditAddressPage(address: item, index: index),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
                      onPressed: () {
                        addressLogic.removeAddress(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
