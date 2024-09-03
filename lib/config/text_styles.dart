import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
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

  static TextStyle titleStyle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: Color(0xFF00618A),
  );

  static TextStyle subtitleStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFF005E86),
  );
  static TextStyle body = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );
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

  static TextStyle textItemDrawer = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFFFFFF),
  );

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
  static TextStyle notification = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFFFFFF),
  );
}
