import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  Header({super.key, required this.context});

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(AppSizes.paddingM),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: AppSizes.iconM,
              height: AppSizes.iconM,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowBase.withOpacity(0.1),
                    blurRadius: AppSizes.spacingM,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:  Icon(
                Icons.arrow_back_ios_new,
                size: AppSizes.iconS,
                color: AppColors.grey600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
