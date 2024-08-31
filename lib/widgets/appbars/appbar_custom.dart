import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/text_styles.dart';

AppBar appBarCustom({
  required BuildContext context,
  required String title,
  GestureTapCallback? func,
}) {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        if (func != null) {
          func!();
        }
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(left: 15.w),
        child: SvgPicture.asset(
          "assets/icons/arrow_back.svg",
          fit: BoxFit.scaleDown,
          width: 28.w,
          height: 28.h,
        ),
      ),
    ),
    backgroundColor: AppColors.appbarColor,
    centerTitle: true,
    title: Text(title, style: AppTextStyles.heading),
  );
}
