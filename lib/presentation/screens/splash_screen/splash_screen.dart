import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saree3/constants/constants.dart';

import '../../../bottom_bar.dart';
import '../auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      final checkLogin = FirebaseAuth.instance.currentUser != null;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => checkLogin ? BottomBar() : LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7a0000),
      body: Center(child: Image.asset(Images.logo)),
    );
  }
}
