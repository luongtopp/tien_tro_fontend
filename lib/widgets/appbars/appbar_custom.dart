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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GestureTapCallback? func;
  final GestureTapCallback? funcOption;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.func,
    this.funcOption,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: func,
        child: Container(
          margin: EdgeInsets.only(left: 15.w),
          child:
              const Icon(Icons.menu_rounded, color: AppColors.backgroundColor),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: funcOption,
          child: Container(
            margin: EdgeInsets.only(right: 15.w),
            child: const Icon(Icons.more_vert_rounded,
                color: AppColors.backgroundColor),
          ),
        ),
      ],
      backgroundColor: backgroundColor,
      centerTitle: true,
      title: Text(title,
          style: AppTextStyles.titleStyle
              .copyWith(fontSize: 16.sp, color: Colors.white)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
