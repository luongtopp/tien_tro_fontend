import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../config/app_color.dart';
import '../config/text_styles.dart';

Widget formattedAmount(double amount, {bool isTotalExpense = false}) {
  final formattedAmount =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(amount);
  return Text(
    formattedAmount,
    style: isTotalExpense
        ? AppTextStyles.bodyMedium.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          )
        : AppTextStyles.bodyRegular.copyWith(
            color: amount >= 0 ? Colors.green : Colors.red,
          ),
  );
}
