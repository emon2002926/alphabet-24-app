import 'package:flutter/material.dart';
import '../theme/SColor.dart';
import '../theme/text_theme.dart';

class SearchWidget extends StatelessWidget {

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String hintText;

  const SearchWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search Your match',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: SColor.bodyColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: SColor.borderColor,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: STextTheme.subHeadLine().copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'sfPro',
            color: SColor.textSecondary.withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: Icon(
            Icons.search,
            color: SColor.textSecondary.withOpacity(0.6),
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}