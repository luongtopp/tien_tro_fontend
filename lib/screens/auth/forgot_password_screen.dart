import 'package:chia_se_tien_sinh_hoat_tro/blocs/forgot_password_bloc/forgot_password_events.dart';
import 'package:chia_se_tien_sinh_hoat_tro/utils/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/forgot_password_bloc/forgot_password_blocs.dart';
import '../../blocs/forgot_password_bloc/forgot_password_states.dart';
import '../../config/text_styles.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/validators.dart';
import '../../widgets/appbars/appbar_custom.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/textfields/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        switch (state) {
          case ForgotPasswordValidating():
            LoadingOverlay.show(context);
            break;

          case ForgotPasswordSuccess():
            LoadingOverlay.hide();
            Navigator.pop(context);
            break;
          case ForgotPasswordNotification():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.notificationMessage,
                type: SnackBarType.success);
            break;
          case ForgotPasswordFailure():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.error, type: SnackBarType.error);
          case ForgotPasswordError():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.error, type: SnackBarType.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarCustom(context: context, title: 'Quên mật khẩu'),
        body: SafeArea(
          child: Container(
            width: 430.w,
            padding: EdgeInsets.only(
              left: 15.w,
              right: 15.w,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 89.h),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.alternate_email_rounded,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email không được để trống';
                      }
                      if (!isValidEmail(value)) {
                        return 'Định dạng email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    text: 'Xác nhận',
                    width: 288.h,
                    height: 85.h,
                    color: const Color(0xFF00618A),
                    textStyle: TextStyles.filledButton,
                    borderRadius: 67.w,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ForgotPasswordBloc>().add(
                              SubmitForgotPassword(_emailController.text),
                            );
                      }
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
