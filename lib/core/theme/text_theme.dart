import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';

import 'SColor.dart';

import 'package:google_fonts/google_fonts.dart';

class STextTheme {
  static TextStyle headLine() {
    return GoogleFonts.poppins(
      color: SColor.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle scoureText() {
    return GoogleFonts.poppins(
      color: SColor.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w900,
    );
  }
  static TextStyle scoureTextNormal() {
    return GoogleFonts.poppins(
      color: SColor.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle subHeadLine() {
    return GoogleFonts.poppins(
      color: SColor.textSecondary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }
}