import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../bussines_logic/verify/verify_cubit.dart';
import '../../../bussines_logic/verify/verify_state.dart';
import '../../../constants/constants.dart';
import '../../widgets/auth/customButton.dart';
import '../../widgets/auth/linkText.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    // _timer?.cancel();
    super.dispose();
  }

  String get _enteredOtp => _otpControllers.map((c) => c.text).join();

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
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Gap(190.h),
                Text(
                  "Forget Password",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(AppSizes.spacingS),
                Text(
                  "Please sign in to your existing account",
                  style: TextStyle(color: AppColors.white, fontSize: 15.sp),
                ),
                Gap(100.h),
                Container(
                  width: double.infinity,
                  height: 500.h,
                  padding: EdgeInsets.all(AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusXL),
                      topRight: Radius.circular(AppSizes.radiusXL),
                    ),
                  ),

                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                      vertical: AppSizes.paddingL,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Gap(50.h),
                          BlocBuilder<VerifyLogic, VerifyState>(
                            builder: (context, state) {
                              final verifyLogic = context.read<VerifyLogic>();

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "CODE",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  (verifyLogic.secondsRemaining > 0)
                                      ? Text(
                                          "Resend in ${verifyLogic.secondsRemaining}s",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.black,
                                          ),
                                        )
                                      : linkText(
                                          text: "Resend",
                                          onPressed: () {
                                            verifyLogic.resetTimer();
                                          },
                                        ),
                                ],
                              );
                            },
                          ),
                          Gap(AppSizes.fieldSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                width: 70.w,
                                height: 70.h,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    filled: true,
                                    fillColor: AppColors.background,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusS,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    // keep only last char if user pasted more than 1
                                    if (value.length > 1) {
                                      final last = value.substring(
                                        value.length - 1,
                                      );
                                      _otpControllers[index].text = last;
                                      _otpControllers[index].selection =
                                          TextSelection.collapsed(offset: 1);
                                    }
                                    if (value.isNotEmpty) {
                                      if (index < 3) {
                                        FocusScope.of(
                                          context,
                                        ).requestFocus(_focusNodes[index + 1]);
                                      } else {
                                        FocusScope.of(context).unfocus();
                                      }
                                    } else {
                                      if (index > 0) {
                                        FocusScope.of(
                                          context,
                                        ).requestFocus(_focusNodes[index - 1]);
                                      }
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          Spacer(),

                          // Verify button (uses your TheButton widget)
                          customButton(
                            text: "Verify",
                            onPressed: () {
                              final otp = _enteredOtp;
                              if (otp.length < 4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Enter 4-digit code'),
                                  ),
                                );
                                return;
                              }
                              debugPrint("Entered OTP: $otp");
                            },
                            color: AppColors.primary,
                            radius: AppSizes.buttonRadius,
                            height: AppSizes.buttonHeight,
                            width: double.infinity,
                          ),
                        ],
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
  }
}
