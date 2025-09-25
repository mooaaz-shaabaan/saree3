import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:saree3/bussines_logic/data_user/data_user_cubit.dart';

import '../../../../constants/constants.dart';
import '../../../widgets/profile/customTextButton.dart';
import '../../../widgets/profile/customTextField.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  String? _profilePhoto;
  bool _initialized = false;
  // XFile? imageSelected;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final dataUser = context.watch<DataUserLogic>();

  //   });
  // }

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
    return BlocBuilder<DataUserLogic, DataUserState>(
      builder: (context, state) {
        final dataUser = context.watch<DataUserLogic>();
        _profilePhoto = dataUser.image;
        if (state is DataUserInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if ((state is GetData || state is SetData) && !_initialized) {
          _nameController.text = dataUser.fullName;
          _emailController.text = dataUser.email;
          _phoneController.text = dataUser.phoneNumber;
          _bioController.text = dataUser.bio;

          _initialized = true; // 👈 كده عمره ما هيعيد يفضيهم
        }
        return Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
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
                              padding: EdgeInsets.all(8.h),
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
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 16,
                              ),
                            ),
                          ),
                          Gap(12.w),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Gap(26.h),

                      // avatar with edit button
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: AppColors.avatarBg,
                              backgroundImage: _profilePhoto != null
                                  ? NetworkImage(_profilePhoto!)
                                  : NetworkImage(Images.firstImageProfile),
                              // child: CircularProgressIndicator(
                              //   color: AppColors.primary,
                              // ),
                            ),

                            // Edit Photo
                            Positioned(
                              right: 6,
                              bottom: 10,
                              child: GestureDetector(
                                onTap: () {
                                  dataUser.uploadAndSaveProfilePhoto();
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
                      Gap(28.h),
                      // form fields
                      Text(
                        'FULL NAME',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      Gap(8),
                      customTextField(
                        _nameController,
                        hint: 'Full name',
                        fillColor: AppColors.fieldFill,
                      ),

                      Gap(14.h),
                      Text(
                        'EMAIL',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      Gap(8.h),
                      customTextField(
                        _emailController,
                        hint: 'Email',
                        fillColor: AppColors.fieldFill,
                      ),

                      Gap(14.h),
                      Text(
                        'PHONE NUMBER',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      Gap(8.h),
                      customTextField(
                        _phoneController,
                        hint: 'Phone number',
                        fillColor: AppColors.fieldFill,
                      ),

                      Gap(14.h),
                      Text(
                        'BIO',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      Gap(8.h),
                      customTextField(
                        _bioController,
                        hint: 'Short bio',
                        fillColor: AppColors.fieldFill,
                        maxLines: 4,
                      ),

                      Gap(26.h),

                      // Save button
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: () {
                              dataUser.setData(
                                newImage: _profilePhoto!,
                                newEmail: _emailController.text,
                                newFullName: _nameController.text,
                                newPhoneNumber: _phoneController.text,
                                newBio: _bioController.text,
                              );
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                title: 'Saved: ${_nameController.text}',
                              ).show();

                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
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
          ),
        );
      },
    );
  }
}
