import 'dart:ui';

import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final IconData? actionIcon;
  final bool disableBackdropFilter;
  final TextStyle? titleStyle;
  final bool disableBlurOnScroll;

  const CustomAppBar({
    super.key,
    required this.title,
    this.func,
    this.funcOption,
    this.backgroundColor,
    this.leadingIcon,
    Color? iconColor,
    this.isTransparent,
    this.actionIcon,
    this.disableBackdropFilter = false,
    this.titleStyle,
    this.disableBlurOnScroll = false,
  }) : iconColor = iconColor ?? AppColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: disableBlurOnScroll ? 0 : null,
      backgroundColor: isTransparent == true
          ? Colors.transparent
          : backgroundColor ?? AppColors.backgroundColor,
      elevation: 0,
      flexibleSpace: disableBackdropFilter
          ? null
          : ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.white.withOpacity(0),
                ),
              ),
            ),
      leading: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          func?.call();
        },
        child: Container(
          padding: EdgeInsets.only(left: 15.w),
          child: Icon(leadingIcon, color: iconColor),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            funcOption?.call();
          },
          child: Container(
            padding: EdgeInsets.only(right: 15.w),
            child: Icon(actionIcon ?? Icons.more_vert_rounded,
                color: AppColors.backgroundColor),
          ),
        ),
      ],
      centerTitle: true,
      title: Text(title, style: titleStyle ?? AppTextStyles.titleStyle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
