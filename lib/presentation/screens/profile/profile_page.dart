import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:saree3/bussines_logic/auth/auth_logic.dart';

import '../../widgets/widgets/profile/customItemsProfilePage.dart';
import '../cart/cart_page.dart';
import 'address/address_page.dart';
import 'edit_profile_page/edit_profile_page.dart';
import 'favorite/favorite_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProfileItems> menuItems = [
      ProfileItems(
        icon: Icons.person_outline,
        title: 'Personal Info',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => EditProfilePage()),
        ),
      ),
      ProfileItems(
        icon: Icons.location_on_outlined,
        title: 'Addresses',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => MyAddressPage()),
        ),
      ),
      ProfileItems(
        icon: Icons.shopping_cart_outlined,
        title: 'Cart',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => CartPage()),
        ),
      ),
      ProfileItems(
        icon: Icons.favorite_outline,
        title: 'Favourite',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => FavoritePage()),
        ),
      ),
      ProfileItems(
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        color: Colors.orange,
        onTap: () {},
      ),
      ProfileItems(
        icon: Icons.payment_outlined,
        title: 'Payment Method',
        color: Colors.blue,
        onTap: () {},
      ),
      ProfileItems(
        icon: Icons.help_outline,
        title: 'FAQs',
        color: Colors.orange,
        onTap: () {},
      ),
      ProfileItems(
        icon: Icons.star_outline,
        title: 'User Reviews',
        color: Colors.cyan,
        onTap: () {},
      ),
      ProfileItems(
        icon: Icons.settings_outlined,
        title: 'Settings',
        color: Colors.purple,
        onTap: () {},
      ),
      ProfileItems(
        icon: Icons.logout,
        title: 'Log Out',
        color: Colors.red,
        onTap: () {
          context.read<AuthLogic>().logOut(context);
        },
      ),
    ];
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 50.h,
          bottom: 20.w,
          right: 20.h,
          left: 20.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Column(
                  children: [
                    // Profile Picture
                    Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3CD),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'VK',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ),
                    Gap(15.h),
                    // Name
                    Text(
                      'Vishal Khadok',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Gap(5.h),
                    // Subtitle
                    Text(
                      'I love fast food',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Gap(20.h),
              // Menu Items
              Container(
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 20.r,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: customItemProfilePage(menuItems: menuItems),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileItems {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  ProfileItems({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
}
