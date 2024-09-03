import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF00618A);
  static const Color errorColor = Color(0xFFFF4545);
  static const Color failedColor = Color(0xFF757575);
  static const Color successColor = Color(0xFF27A13D);
  static const Color selectionColor = Color(0xFF91BDF3);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color appbarColor = Color(0xFFFFFFFF);
  static const Color textFillColor = Color(0xFFDCDCDC);
  static const Color buttonOutLineColor = Color(0xFFFFFFFF);
  static const Color buttonFillColor = Color(0xFF00618A);
  static const Color borderImageColor = Color(0xFFC9C9C9);
  static const Color iconDrawerColor = Color(0xFFFFFFFF);
  static const Color iconDrawerSelectedColor = Color(0xFF1898CF);
  static const Color iconDrawerNoSelectedColor = Color(0xFF013B54);

  static const Color iconDrawerSelectedTextColor = Color(0xFFFFFFFF);
  static const Color iconDrawerNoSelectedTextColor = Color(0xFF00618A);

  static const LinearGradient backgroundColorLinear = LinearGradient(
    colors: [Color(0xFF00618A), Color(0xFFD2D2D2)],
    stops: [0.5, 1],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
