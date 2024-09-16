import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';

class AppTextStyles {
  // Headings
  static TextStyle heading = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFF4C4C4C),
  );

  static TextStyle headingDrawer = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle subheading = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 2, 54, 79),
  );

  // Titles
  static TextStyle titleSmall = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Color(0xFF00618A),
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFF00618A),
  );

  static TextStyle titleLarge = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFF00618A),
  );

  static TextStyle titleExtraLarge = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFF00618A),
  );

  // Body text
  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: Colors.grey[700],
  );

  static TextStyle bodyRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle bodyBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle bodyExtraLarge = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle bodyItalic = TextStyle(
    fontSize: 14.sp,
    fontStyle: FontStyle.italic,
    color: Colors.black87,
  );

  static TextStyle bodyUnderline = TextStyle(
    fontSize: 14.sp,
    decoration: TextDecoration.underline,
    color: Colors.black87,
  );

  // Buttons
  static TextStyle filledButton = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static TextStyle outlinedButton = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
  );

  static TextStyle textButton = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryColor,
  );

  // Drawer items
  static TextStyle textItemDrawerSelected = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle textItemDrawerNoSelected = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xff0c8bc2),
  );

  // Other
  static TextStyle subtitleStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFF005E86),
  );

  static TextStyle notification = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFFFFFF),
  );
}
