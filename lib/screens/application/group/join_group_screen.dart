import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../blocs/group_bloc/group_bloc.dart';
import '../../../blocs/group_bloc/group_event.dart';
import '../../../blocs/group_bloc/group_state.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../routes/app_route.dart';
import '../../../utils/loading_overlay.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../widgets/appbars/appbar_custom.dart';
import '../../../widgets/buttons/custom_button.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({Key? key}) : super(key: key);

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
  }

  void _handleGroupState(BuildContext context, GroupState state) {
    switch (state) {
      case GroupValidating():
        LoadingOverlay.show(context);
        break;
      case GroupFailure():
        LoadingOverlay.hide();
        showCustomSnackBar(context, state.error, type: SnackBarType.failed);
        break;
      case GroupError():
        LoadingOverlay.hide();
        showCustomSnackBar(context, state.error, type: SnackBarType.error);
        break;
      case GroupSuccess():
        LoadingOverlay.hide();
        showCustomSnackBar(context, state.message, type: SnackBarType.success);
        break;
      case JoinGroupSuccess():
        LoadingOverlay.hide();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.ZOOM_DRAWER_SCREEN,
            (Route<dynamic> route) => false,
            arguments: [state.groups, state.user],
          );
        });
        break;
    }
  }

  void _submitJoinGroup() {
    if (_formKey.currentState!.validate()) {
      context.read<GroupBloc>().add(JoinGroup(_codeController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: _handleGroupState,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: appBarCustom(
          context: context,
          title: "Tham gia nhóm",
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Text(
                      'Nhập mã nhóm',
                      style: AppTextStyles.subheading,
                    ),
                    SizedBox(height: 16.h),
                    _buildPinCodeTextField(),
                    SizedBox(height: 24.h),
                    _buildJoinButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Mã nhóm không được để trống';
        }

        return null;
      },
      animationType: AnimationType.fade,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      controller: _codeController,
      appContext: context,
      length: 6,
      textStyle:
          AppTextStyles.subheading.copyWith(color: AppColors.primaryColor),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10.r),
        fieldHeight: 50.h,
        fieldWidth: 50.w,
        inactiveColor: AppColors.borderImageColor,
        activeColor: AppColors.primaryColor,
        selectedColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildJoinButton() {
    return CustomButton(
      text: 'Tham gia nhóm',
      width: 288.w,
      height: 85.h,
      color: AppColors.primaryColor,
      borderRadius: 67.r,
      onTap: _submitJoinGroup,
      textStyle: AppTextStyles.filledButton,
    );
  }
}
