import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/forgot_password_bloc/forgot_password_blocs.dart';
import '../../blocs/forgot_password_bloc/forgot_password_events.dart';
import '../../blocs/forgot_password_bloc/forgot_password_states.dart';
import '../../config/app_color.dart';
import '../../config/text_styles.dart';
import '../../utils/loading_overlay.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/validators.dart';
import '../../widgets/appbars/appbar_custom.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/textfields/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgotPasswordState(
      BuildContext context, ForgotPasswordState state) {
    LoadingOverlay.hide();
    switch (state) {
      case ForgotPasswordValidating():
        LoadingOverlay.show(context);
        break;
      case ForgotPasswordSuccess():
        Navigator.pop(context);
        break;
      case ForgotPasswordNotification():
        showCustomSnackBar(context, state.notificationMessage,
            type: SnackBarType.success);
        break;
      case ForgotPasswordFailure():
        showCustomSnackBar(context, state.error, type: SnackBarType.error);
        break;
      case ForgotPasswordError():
        showCustomSnackBar(context, state.error, type: SnackBarType.error);
        break;
    }
  }

  void _submitForgotPassword() {
    if (_formKey.currentState!.validate()) {
      context
          .read<ForgotPasswordBloc>()
          .add(SubmitForgotPassword(_emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: _handleForgotPasswordState,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: appBarCustom(context: context, title: 'Quên mật khẩu'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 89.h),
                    _buildEmailField(),
                    SizedBox(height: 24.h),
                    _buildSubmitButton(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      hintText: 'Email',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.alternate_email_rounded,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email không được để trống';
        }
        if (!isValidEmail(value)) {
          return 'Định dạng email không hợp lệ';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: 'Xác nhận',
      width: 288.h,
      height: 85.h,
      color: const Color(0xFF00618A),
      textStyle: AppTextStyles.filledButton,
      borderRadius: 67.r,
      onTap: _submitForgotPassword,
    );
  }
}
