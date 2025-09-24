import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:saree3/bussines_logic/auth/auth_logic.dart';
import 'package:saree3/bussines_logic/auth/auth_state.dart';

import '../../../bussines_logic/signUp/signup_cubit.dart';
import '../../../bussines_logic/signUp/signup_state.dart';
import '../../../constants/constants.dart';
import '../../widgets/auth/customButton.dart';
import '../../widgets/auth/customDropdown.dart';
import '../../widgets/auth/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

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
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Gap(134.h),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gap(AppSizes.spacingS),
                  Text(
                    "Please sign up to get Started",
                    style: TextStyle(color: AppColors.white, fontSize: 15),
                  ),
                  Gap(AppSizes.spacingL),
                  Container(
                    width: double.infinity,
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                // First Name
                                Expanded(
                                  child: customTextFormField(
                                    label: 'First Name',
                                    hintText: 'John',
                                    controller: firstNameController,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return "Please Enter First Name";
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                Gap(15.w),

                                // Second Name
                                Expanded(
                                  child: customTextFormField(
                                    label: 'Second Name',
                                    hintText: 'Doe',
                                    controller: secondNameController,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return "Please Enter Second Name";
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Gap(AppSizes.spacingL),

                            // Email
                            customTextFormField(
                              label: 'Email',
                              hintText: 'example@gmail.com',
                              controller: emailController,
                              icon: const Icon(Icons.account_circle_outlined),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Please Enter Email";
                                }

                                return null;
                              },
                            ),
                            Gap(AppSizes.spacingL),

                            // Password
                            BlocBuilder<SignUpLogic, SignUpState>(
                              builder: (context, state) {
                                SignUpLogic signUpLogic = context
                                    .read<SignUpLogic>();
                                return customTextFormField(
                                  password: true,
                                  obscureText: signUpLogic.obSecure,
                                  onPressed: () => signUpLogic.showPassword(),
                                  label: 'Password',
                                  controller: passwordController,
                                  hintText: '***********',
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return "Please Enter Password";
                                    }
                                    if (v.length < 8) {
                                      return "Please enter at least 8 characters";
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            Gap(AppSizes.spacingL),

                            // Re-type Password
                            BlocBuilder<SignUpLogic, SignUpState>(
                              builder: (context, state) {
                                SignUpLogic signUpLogic = context
                                    .read<SignUpLogic>();
                                return customTextFormField(
                                  password: true,
                                  obscureText: signUpLogic.obSecure,
                                  onPressed: () => signUpLogic.showPassword(),
                                  label: 'Password',
                                  controller: rePasswordController,

                                  hintText: '***********',
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return "Please Enter Password";
                                    }
                                    if (v.length < 8) {
                                      return "Please enter at least 8 characters";
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            Gap(AppSizes.fieldSpacing),

                            // Gender Dropdown
                            BlocBuilder<SignUpLogic, SignUpState>(
                              builder: (context, state) {
                                SignUpLogic signUpLogic = context
                                    .read<SignUpLogic>();
                                return customDropdown<String>(
                                  color: AppColors.background,
                                  radius: AppSizes.buttonRadius,
                                  value: signUpLogic.selectedGender,
                                  items: signUpLogic.genders,
                                  hint: "Gender",
                                  onChanged: (val) {
                                    signUpLogic.updateGender(val);
                                  },
                                );
                              },
                            ),
                            Gap(AppSizes.spacingXL),

                            // Confirm Button
                            Center(
                              child: BlocBuilder<AuthLogic, AuthState>(
                                builder: (context, state) {
                                  AuthLogic authLogic = context
                                      .read<AuthLogic>();
                                  return customButton(
                                    text: 'Confirm',
                                    onPressed: () {
                                      if (passwordController.text !=
                                          rePasswordController.text) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Passwords do not match',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        authLogic.signUp(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          name:
                                              "${firstNameController.text} ${secondNameController.text}",
                                          context: context,
                                        );
                                      }
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         const VerificationPage(),
                                      //   ),
                                      // );
                                    },
                                    color: AppColors.primary,
                                    radius: AppSizes.buttonRadius,
                                    height: AppSizes.buttonHeight,
                                    width: 150.w,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
