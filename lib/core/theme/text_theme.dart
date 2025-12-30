import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';

import 'SColor.dart';

class STextTheme{

  static TextStyle headLine() {
    return TextStyle(
      fontFamily: 'sfPro',
      color: SColor.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w900,
    );
  }

  static TextStyle scoureText() {
    return TextStyle(
      fontFamily: 'sfPro',
      color: SColor.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w900,
    );
  }

  static TextStyle subHeadLine() {
    return TextStyle(
      fontFamily: 'sfPro',
      color: SColor.textSecondary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

}