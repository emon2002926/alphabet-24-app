import 'package:flutter/material.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';

import '../const/size_const/dynamic_size.dart';
import '../theme/SColor.dart';
class STextField extends StatefulWidget {
  String? hintText;
  String? labelText;
  TextEditingController? controller;
  bool? obscureText;
  bool? isEnabled;
  TextInputType? keyboardType;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Widget? changedSuffixIcon;
  Function(String)? onChanged; // ADD THIS

  STextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.isEnabled = true,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.changedSuffixIcon,
    this.onChanged, // ADD THIS
  });

  @override
  State<STextField> createState() => _STextFieldState();
}

class _STextFieldState extends State<STextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isEnabled,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged, // ADD THIS
      decoration: InputDecoration(
        filled: true,
        fillColor: SColor.bodyColor,
        hintText: widget.hintText ?? '',
        label: Text(widget.labelText ?? ''),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon != null
            ? GestureDetector(
          onTap: _toggleObscureText,
          child: _obscureText
              ? widget.suffixIcon
              : widget.changedSuffixIcon ?? widget.suffixIcon,
        )
            : null,
        labelStyle: STextTheme.subHeadLine(),
        hintStyle: STextTheme.subHeadLine(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: SColor.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: SColor.borderColor),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: DynamicSize.horizontalMedium(context),
          vertical: DynamicSize.small(context),
        ),
      ),
    );
  }
}