import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF00618A);
  static const Color errorColor = Color(0xFFFF4545);
  static const Color successColor = Color(0xFF27A13D);
  static const Color selectionColor = Color(0xFF91BDF3);

  static const LinearGradient backgroundColor = LinearGradient(
    colors: [Color(0xFF00618A), Color(0xFFD2D2D2)],
    stops: [0.5, 1],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
