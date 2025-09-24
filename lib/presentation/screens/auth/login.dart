import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:saree3/bussines_logic/auth/auth_logic.dart';
import 'package:saree3/bussines_logic/auth/auth_state.dart';
import 'package:saree3/presentation/screens/auth/forgetpassword_page.dart';
import 'package:saree3/presentation/screens/auth/signup.dart';

import '../../../bussines_logic/login/login_cubit.dart';
import '../../../bussines_logic/login/login_state.dart';
import '../../../constants/constants.dart';
import '../../widgets/auth/checkboxButton.dart';
import '../../widgets/auth/customButton.dart';
import '../../widgets/auth/linkText.dart';
import '../../widgets/auth/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
          Positioned(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Gap(210.h),
                    Text(
                      "Log In",
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
                          // Email
                          customTextFormField(
                            hintText: 'example@gmail.com',
                            label: 'Email',
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter mail";
                              }
                              return null;
                            },
                            icon: null,
                          ),

                          // Password
                          BlocBuilder<LoginLogic, LoginState>(
                            builder: (context, state) {
                              LoginLogic loginLogic = context
                                  .read<LoginLogic>();
                              return customTextFormField(
                                password: true,
                                obscureText: loginLogic.obSecure,
                                onPressed: () => loginLogic.showPassword(),
                                label: 'Password',
                                controller: passwordController,
                                hintText: '********',
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

                          // Login Button
                          BlocBuilder<AuthLogic, AuthState>(
                            builder: (context, state) {
                              AuthLogic authLogic = context.read<AuthLogic>();
                              return customButton(
                                text: 'LOG IN',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    authLogic.login(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context,
                                    );
                                  }
                                },
                                color: AppColors.primary,
                                radius: AppSizes.buttonRadius,
                                height: AppSizes.buttonHeight,
                                width: 200.w,
                              );
                            },
                          ),

                          // Remember me + Forget Password
                          Row(
                            children: [
                              BlocBuilder<LoginLogic, LoginState>(
                                builder: (context, state) {
                                  LoginLogic loginLogic = context
                                      .read<LoginLogic>();
                                  return checkboxButton(
                                    value: loginLogic.rememberMe,
                                    onChanged: (v) {
                                      loginLogic.rememberrMe(v);
                                    },
                                    label: "Remember me",
                                    activeColor: AppColors.appbarColor,
                                  );
                                },
                              ),
                              const Spacer(),
                              linkText(
                                color: AppColors.primary,
                                text: 'Forget Password?',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetPasswordPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              Gap(10.w),
                              linkText(
                                color: AppColors.primary,
                                text: 'SIGN UP',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
