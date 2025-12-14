import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SColor {
  // === Background Color === //
  static Color get bodyColor =>
      Get.theme.brightness == Brightness.dark
          ? const Color(0xFF121212)
          : const Color(0xFFFFFFFF);

  // === Primary Colors === //
  static const Color primary = Color(0xFF005440);
  static const Color secondary = Color(0xFF28F4AF);

  // === Text Colors === //
  static Color get textPrimary =>
      Get.theme.brightness == Brightness.dark
          ? const Color(0xFFEEEEEE)
          : const Color(0xFF282828);

  static Color get textSecondary =>
      Get.theme.brightness == Brightness.dark
          ? const Color(0xFFB0B0B0)
          : const Color(0xFF9C9C9C);

  // === Border Colors === //
  static Color get borderColor =>
      Get.theme.brightness == Brightness.dark
          ? const Color(0xFF2A2A2A)
          : const Color(0xFFE0E0E0);

  // === Progress Indicator Colors === //
  static const Color progressIndicator1 = Color(0xFF28F4AF);
  static const Color progressIndicator2 = Color(0xFF9C9C9C);
  static const Color progressIndicator3 = Color(0xFFFFE418);
}
