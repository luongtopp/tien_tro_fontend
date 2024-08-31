import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/app_color.dart';

Future<int?> showCustomModalBottomSheet({
  required BuildContext context,
  required List<Widget> buttons,
}) {
  return showModalBottomSheet<int>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: AppColors.backgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: buttons,
            ),
          ),
        ),
      );
    },
  );
}
