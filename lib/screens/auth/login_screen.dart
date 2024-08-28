import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/login_bloc/login_blocs.dart';
import '../../blocs/login_bloc/login_events.dart';
import '../../blocs/login_bloc/login_states.dart';
import '../../config/text_styles.dart';
import '../../routes/app_route.dart';
import '../../utils/loading_overlay.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/validators.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/textfields/custom_textfield.dart';
import 'auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        switch (state) {
          case LoginValidating():
            LoadingOverlay.show(context);
            break;
          case LoginSuccess():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.message,
                type: SnackBarType.success);
            // Navigator.of(context).pushReplacementNamed(AppRoutes.APPLICATION);
            break;
          case LoginFailure():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.error, type: SnackBarType.failed);
          case LoginError():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.error, type: SnackBarType.error);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 48.w, right: 48.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 89.h),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 238.w,
                      height: 236.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 51.h),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
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
                  CustomTextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Mật khẩu',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mật khẩu không được để trống';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 43.h),
                  Container(
                    alignment: Alignment.centerRight,
                    width: 333.w,
                    child: textButton(
                      text: 'Quên mật khẩu?',
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.FORGOT_PASSWORD);
                      },
                    ),
                  ),
                  SizedBox(height: 46.h),
                  CustomButton(
                    text: 'Đăng Nhập',
                    width: 288.h,
                    height: 85.h,
                    color: AppColors.primaryColor,
                    textStyle: TextStyles.filledButton,
                    borderRadius: 67.w,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(
                              SubmitLogin(
                                email: _emailController.text,
                                password: _passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                  SizedBox(height: 21.h),
                  buttonLoginGoogle(() {
                    context.read<LoginBloc>().add(LoginWithGoogle());
                  }),
                  SizedBox(height: 24.h),
                  textButtonSignUp(() {
                    Navigator.of(context).pushNamed(AppRoutes.REGISTER);
                  }),
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
