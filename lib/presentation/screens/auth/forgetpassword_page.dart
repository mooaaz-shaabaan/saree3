import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:saree3/presentation/screens/auth/verification_Page.dart';

import '../../../constants/constants.dart';
import '../../widgets/auth/customButton.dart';
import '../../widgets/auth/custom_text_field.dart';

class ForgetPasswordPage extends StatelessWidget {
  ForgetPasswordPage({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(Images.backgroundImage, fit: BoxFit.fill),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(AppSizes.spacingS),
                Text(
                  "Enter your email to reset your password",
                  style: TextStyle(color: AppColors.white, fontSize: 15.sp),
                ),
                Gap(AppSizes.spacingXL),
                Container(
                  height: 550.h,
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusXL),
                      topRight: Radius.circular(AppSizes.radiusXL),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Email Field
                      customTextFormField(
                        hintText: 'example@gmail.com',
                        label: 'Email',
                        controller: emailController,
                        icon: const Icon(Icons.email_outlined),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Please Enter Email";
                          }

                          return null;
                        },
                      ),

                      Gap(AppSizes.spacingXL),

                      // Send Verification Button
                      customButton(
                        text: "Send Verification",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerificationPage(),
                            ),
                          );
                        },
                        color: AppColors.primary,
                        radius: AppSizes.buttonRadius,
                        height: AppSizes.buttonHeight,
                        width: 220.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
