import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../constants/constants.dart';
import '../../../widgets/widgets/profile/customTextButton.dart';
import '../../../widgets/widgets/profile/customTextField.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'Vishal Khadok');
  final _emailController = TextEditingController(text: 'hello@halallab.co');
  final _phoneController = TextEditingController(text: '408-841-0926');
  final _bioController = TextEditingController(text: 'I love fast food');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // back + title
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.maybePop(context),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding:  EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6.r,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 16),
                      ),
                    ),
                    Gap( 12.w),
                     Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Gap( 26.h),

                // avatar with edit button
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: AppColors.avatarBg,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // optional: put initials or image
                      const Positioned(
                        top: 44,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: Colors.white70,
                        ),
                      ),
                      Positioned(
                        right: 6,
                        bottom: 10,
                        child: GestureDetector(
                          onTap: () {
                            //TODO: open image picker
                          },
                          child: Container(
                            width: 36.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 6.r,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap( 28.h),

                // form fields
                 Text(
                  'FULL NAME',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                Gap( 8),
                customTextField(
                  _nameController,
                  hint: 'Full name',
                  fillColor: AppColors.fieldFill,
                ),

                Gap( 14.h),
                 Text(
                  'EMAIL',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                Gap( 8.h),
                customTextField(
                  _emailController,
                  hint: 'Email',
                  fillColor: AppColors.fieldFill,
                ),

                Gap( 14.h),
                 Text(
                  'PHONE NUMBER',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                Gap( 8.h),
                customTextField(
                  _phoneController,
                  hint: 'Phone number',
                  fillColor: AppColors.fieldFill,
                ),

                Gap( 14.h),
                 Text(
                  'BIO',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                Gap( 8.h),
                customTextField(
                  _bioController,
                  hint: 'Short bio',
                  fillColor: AppColors.fieldFill,
                  maxLines: 4,
                ),

                Gap( 26.h),

                // Save button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        // Save action
                        final data = {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'phone': _phoneController.text,
                          'bio': _bioController.text,
                        };
                        // for demo show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Saved: ${data['name']}')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 6,
                      ),
                      child: customTextButton(text: 'save'),
                    ),
                  ),
                ),
                Gap(24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
