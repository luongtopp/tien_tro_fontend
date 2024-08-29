import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/app_color.dart';

Future<int?> showCustomModalBottomSheet({
  required BuildContext context,
  required List<Widget> buttons,
  double height = 260,
}) {
  return showModalBottomSheet<int>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.backgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: buttons,
            ),
          ),
        ),
      );
    },
  );
}
