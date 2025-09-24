import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:saree3/presentation/screens/cart/cart_page.dart';
import 'package:saree3/presentation/screens/homePage/home_page.dart';
import 'package:saree3/presentation/screens/maps/maps_order.dart';
import 'package:saree3/presentation/screens/profile/profile_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  final screens = [HomePage(), CartPage(), MapsOreder(), ProfilePage()];
  String fontFamily = "sen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 8.h, bottom: 8.h, right: 8.w, left: 8.w),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: _currentIndex == 0
                  ? Icon(Icons.home)
                  : Icon(Icons.home_outlined),
              title: Text("Home", style: TextStyle(fontFamily: fontFamily)),
              selectedColor: Colors.red,
            ),

            SalomonBottomBarItem(
              icon: _currentIndex == 1
                  ? Icon(Icons.shopping_cart)
                  : Icon(Icons.shopping_cart_outlined),
              title: Text("Cart", style: TextStyle(fontFamily: fontFamily)),
              selectedColor: Colors.red,
            ),

            SalomonBottomBarItem(
              icon: _currentIndex == 2
                  ? Icon(Icons.map)
                  : Icon(Icons.map_outlined),
              title: Text("Map", style: TextStyle(fontFamily: fontFamily)),
              selectedColor: Colors.red,
            ),

            SalomonBottomBarItem(
              icon: _currentIndex == 3
                  ? Icon(Icons.person)
                  : Icon(Icons.person_outline),
              title: Text("Profile", style: TextStyle(fontFamily: fontFamily)),
              selectedColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
