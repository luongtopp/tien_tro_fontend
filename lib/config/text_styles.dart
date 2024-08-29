import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF4C4C4C),
  );
  static const TextStyle headingDrawer = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 2, 54, 79),
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Color(0xFF00618A),
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Color(0xFF005E86),
  );
  static const TextStyle body = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );
  static const TextStyle filledButton = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  static const TextStyle outlinedButton = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
  );
  static const TextStyle textButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryColor,
  );

  static const TextStyle textItemDrawer = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFFFFFF),
  );
  static const TextStyle textItemDrawerNoSelected = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
  );
  static const TextStyle notification = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFFFFFF),
  );
}
