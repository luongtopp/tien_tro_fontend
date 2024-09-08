import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_route.dart';
import '../../../widgets/buttons/custom_button.dart';

class GroupScreen extends StatefulWidget {
  final UserModel? user;
  const GroupScreen({super.key, this.user});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                width: 288.w,
                height: 85.h,
                text: 'Tạo nhóm',
                textStyle: AppTextStyles.filledButton,
                color: AppColors.buttonFillColor,
                borderRadius: 67.r,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.CREATE_GROUP,
                    arguments: widget.user,
                  );
                },
              ),
              SizedBox(height: 43.h),
              CustomButton(
                isBorder: true,
                width: 288.w,
                height: 85.h,
                text: 'Tham gia nhóm',
                textStyle: AppTextStyles.outlinedButton,
                color: AppColors.buttonOutLineColor,
                borderRadius: 67.r,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.JOIN_GROUP,
                    arguments: widget.user,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
