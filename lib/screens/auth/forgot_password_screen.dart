import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/auth_bloc/auth_blocs.dart';
import '../../blocs/auth_bloc/auth_events.dart';
import '../../blocs/auth_bloc/auth_states.dart';
import '../../config/app_color.dart';
import '../../config/text_styles.dart';
import '../../utils/loading_overlay.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/validators.dart';
import '../../widgets/appbars/custom_appbar.dart';
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

  void _handleForgotPasswordState(BuildContext context, AuthState state) {
    switch (state) {
      case AuthLoading():
        LoadingOverlay.show(context);
        break;
      case AuthSuccess():
        showCustomSnackBar(context, state.message, type: SnackBarType.success);
        Navigator.pop(context);
        break;
      case AuthError():
        showCustomSnackBar(context, state.message, type: SnackBarType.error);
        break;
      default:
        LoadingOverlay.hide();
        break;
    }
  }

  void _submitForgotPassword() {
    if (_formKey.currentState!.validate()) {
      context
          .read<AuthBloc>()
          .add(ForgotPasswordRequested(email: _emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _handleForgotPasswordState,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: 'Quên mật khẩu',
          leadingIcon: Icons.arrow_back_ios_new_rounded,
          iconColor: AppColors.primaryColor,
          func: () {
            Navigator.of(context).pop();
          },
        ),
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
