import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saree3/bussines_logic/serach/search_cubit.dart';

Widget homeSearchBar({required BuildContext context}) {
  return BlocBuilder<SearchLogic, SearchState>(
    builder: (context, state) {
      final objSearch = context.read<SearchLogic>();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            objSearch.searchFuncation(keyWord: value);
          },
          decoration: const InputDecoration(
            hintText: 'Search restaurants',
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.grey),
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      );
    },
  );
}
