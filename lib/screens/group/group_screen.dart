import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/text_styles.dart';
import '../../routes/app_route.dart';
import '../../widgets/buttons/custom_button.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: Container(
          width: 430.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                width: 288.w,
                height: 85.h,
                text: 'Tạo nhóm',
                textStyle: TextStyles.filledButton,
                color: AppColors.buttonFillColor,
                borderRadius: 67.w,
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CREATE_GROUP),
              ),
              SizedBox(height: 43.h),
              CustomButton(
                width: 288.w,
                height: 85.h,
                text: 'Tham gia nhóm',
                isBorder: true,
                color: AppColors.buttonOutLineColor,
                textStyle: TextStyles.outlinedButton,
                borderRadius: 67.w,
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.JOIN_GROUP),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
