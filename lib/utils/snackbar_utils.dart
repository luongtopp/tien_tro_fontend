import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../config/text_styles.dart';

enum SnackBarType { success, failed, error, info }

void showCustomSnackBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
  DismissDirection dismissDirection = DismissDirection.up,
}) {
  // Chọn loại SnackBar dựa trên tham số 'type'
  CustomSnackBar snackBar;
  switch (type) {
    case SnackBarType.success:
      snackBar = CustomSnackBar.success(
        backgroundColor: AppColors.successColor,
        boxShadow: [],
        icon: const SizedBox(),
        textStyle: TextStyles.notification,
        message: message,
      );
      break;
    case SnackBarType.failed:
      snackBar = CustomSnackBar.error(
        backgroundColor: AppColors.failedColor,
        boxShadow: [],
        icon: const SizedBox(),
        textStyle: TextStyles.notification,
        message: message,
      );
      break;
    case SnackBarType.error:
      snackBar = CustomSnackBar.error(
        backgroundColor: AppColors.errorColor,
        boxShadow: [],
        icon: const SizedBox(),
        textStyle: TextStyles.notification,
        message: message,
      );
      break;
    case SnackBarType.info:
      snackBar = CustomSnackBar.info(
        backgroundColor: AppColors.primaryColor,
        boxShadow: [],
        icon: const SizedBox(),
        textStyle: TextStyles.notification,
        message: message,
      );
      break;
  }

  showTopSnackBar(
    Overlay.of(context),
    snackBar,
    dismissType: DismissType.onSwipe,
    safeAreaValues: const SafeAreaValues(
        // maintainBottomViewPadding: true,
        top: false,
        minimum: EdgeInsets.only(top: 40)),
    dismissDirection: [dismissDirection],
    animationDuration: const Duration(milliseconds: 300),
    curve: Curves.linear,
    reverseCurve: Curves.linear,
  );
}
