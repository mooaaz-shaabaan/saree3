import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class buildSearchField extends StatefulWidget {
  const buildSearchField({super.key, required this.controller});
  final TextEditingController? controller;
  @override
  State<buildSearchField> createState() => _buildSearchFieldState();
}

class _buildSearchFieldState extends State<buildSearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black45),
          Gap(8.w),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (widget.controller!.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                widget.controller!.clear();
                setState(() {});
              },
              child: const Icon(Icons.close, color: Colors.black38),
            ),
        ],
      ),
    );
  }
}
