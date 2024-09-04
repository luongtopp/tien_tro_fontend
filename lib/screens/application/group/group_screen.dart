import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/group_bloc/group_bloc.dart';
import '../../../blocs/group_bloc/group_state.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_route.dart';
import '../../../utils/loading_overlay.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../widgets/buttons/custom_button.dart';

class GroupScreen extends StatefulWidget {
  final UserModel? user;
  const GroupScreen({super.key, this.user});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  void _handleGroupState(BuildContext context, GroupState state) {
    switch (state) {
      case GroupValidating():
        LoadingOverlay.show(context);
        break;
      case GroupActionResult():
        LoadingOverlay.hide();
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.ZOOM_DRAWER_SCREEN,
          (Route<dynamic> route) => false,
          arguments: [state.group, widget.user],
        );
        break;
      case GroupError():
        LoadingOverlay.hide();
        showCustomSnackBar(context, state.error, type: SnackBarType.error);
        break;
      default:
        LoadingOverlay.hide();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: _handleGroupState,
      child: Scaffold(
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
                    Navigator.of(context).pushNamed(AppRoutes.CREATE_GROUP);
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
                    Navigator.of(context).pushNamed(AppRoutes.JOIN_GROUP);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
