import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/text_styles.dart';
import '../../utils/modal_bottom_sheet_utils.dart';
import '../buttons/button_modal_bottom_sheet.dart';

Widget accountHeader(String imageUrl, String userName) {
  return Container(
    height: 60,
    padding: EdgeInsets.only(left: 15.w, right: 15.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.r),
      border: Border.all(color: AppColors.borderImageColor, width: 1.5),
    ),
    child: Row(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderImageColor, width: 1),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            userName,
            style: AppTextStyles.headingDrawer,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        )
      ],
    ),
  );
}

void showBottomSheetCustom(BuildContext context, {Function(int)? onButtonTap}) {
  showCustomModalBottomSheet(
    context: context,
    buttons: <Widget>[
      ButtonModalBottomSheet(
        text: 'Tạo nhóm',
        width: double.infinity,
        height: 70,
        color: AppColors.primaryColor,
        textStyle: AppTextStyles.filledButton,
        borderRadius: 20.r,
        onTap: () {
          Navigator.pop(context);
          if (onButtonTap != null) onButtonTap(1);
        },
      ),
      const SizedBox(height: 15),
      ButtonModalBottomSheet(
        text: 'Tham gia nhóm',
        width: double.infinity,
        height: 70,
        color: AppColors.buttonOutLineColor,
        textStyle: AppTextStyles.outlinedButton,
        borderRadius: 20.r,
        isBorder: true,
        onTap: () {
          Navigator.pop(context);
          if (onButtonTap != null) onButtonTap(2);
        },
      )
    ],
  );
}
