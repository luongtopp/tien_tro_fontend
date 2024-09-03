import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../routes/app_route.dart';
import '../../../widgets/buttons/custom_button.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                context: context,
                text: 'Tạo nhóm',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CREATE_GROUP),
                isFilled: true,
              ),
              SizedBox(height: 43.h),
              _buildButton(
                context: context,
                text: 'Tham gia nhóm',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.JOIN_GROUP),
                isFilled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
    required bool isFilled,
  }) {
    return CustomButton(
      width: 288.w,
      height: 85.h,
      text: text,
      textStyle:
          isFilled ? AppTextStyles.filledButton : AppTextStyles.outlinedButton,
      color:
          isFilled ? AppColors.buttonFillColor : AppColors.buttonOutLineColor,
      borderRadius: 67.r,
      onTap: onTap,
      isBorder: !isFilled,
    );
  }
}
