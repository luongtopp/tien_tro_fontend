import 'dart:ui';

import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GestureTapCallback? func;
  final GestureTapCallback? funcOption;
  final Color? backgroundColor;
  final IconData? leadingIcon;
  final Color? iconColor;
  final bool? isTransparent;

  const CustomAppBar({
    super.key,
    required this.title,
    this.func,
    this.funcOption,
    this.backgroundColor,
    this.leadingIcon,
    Color? iconColor,
    this.isTransparent,
  }) : iconColor = iconColor ?? AppColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isTransparent == true
          ? Colors.transparent
          : backgroundColor ?? AppColors.backgroundColor,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.white.withOpacity(0),
          ),
        ),
      ),
      leading: GestureDetector(
        onTap: func,
        child: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Icon(leadingIcon, color: iconColor),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: funcOption,
          child: Container(
            margin: EdgeInsets.only(right: 15.w),
            child:
                Icon(Icons.more_vert_rounded, color: AppColors.backgroundColor),
          ),
        ),
      ],
      centerTitle: true,
      title: Text(title, style: AppTextStyles.titleStyle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
