import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle heading = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF4C4C4C),
  );
  static TextStyle headingDrawer = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle subheading = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 2, 54, 79),
  );

  static TextStyle titleStyle = const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Color(0xFF00618A),
  );

  static TextStyle subtitleStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Color(0xFF005E86),
  );
  static TextStyle body = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );
  static TextStyle filledButton = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  static TextStyle outlinedButton = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
  );
  static TextStyle textButton = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryColor,
  );

  static TextStyle textItemDrawer = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFFFFFF),
  );
  static TextStyle textItemDrawerNoSelected = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
  );
  static TextStyle notification = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFFFFFF),
  );
}
