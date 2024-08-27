import 'dart:io';

import 'package:chia_se_tien_sinh_hoat_tro/blocs/register_bloc/register_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/register_bloc/register_blocs.dart';
import '../../blocs/register_bloc/register_states.dart';
import '../../config/text_styles.dart';
import '../../utils/image_utils.dart';
import '../../utils/loading_overlay.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/validators.dart';
import '../../widgets/appbars/appbar_custom.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/image_pickers/custom_image_picker.dart';
import '../../widgets/textfields/custom_textfield.dart';
import 'auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        switch (state) {
          case RegisterValidating():
            LoadingOverlay.show(context);
            break;
          case RegisterSuccess():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.message,
                type: SnackBarType.success);
            // Navigator.pop(context);
            break;
          case RegisterNotification():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.notificationMessage,
                type: SnackBarType.success);
            Navigator.pop(context);
            break;
          case RegisterFailure():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.error, type: SnackBarType.error);
          case RegisterError():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.error, type: SnackBarType.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarCustom(context: context, title: 'Đăng ký'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 48.w, right: 48.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    CustomImagePicker(
                      onImagePicked: () => pickImage(
                        context: context,
                        onImagePicked: (croppedFile) {
                          setState(() {
                            _selectedImage = croppedFile;
                          });
                        },
                      ),
                      image: _selectedImage,
                    ),
                    SizedBox(height: 51.h),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'Tên tài khoản',
                      prefixIcon: Icons.person_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tên tài khoản không được để trống';
                        }
                        if (!isValidUsername(value)) {
                          return 'Tên tài khoản không hợp lệ. Vui lòng nhập từ 3 đến 30 ký tự, chỉ bao gồm chữ cái, số, dấu chấm (.) và dấu gạch dưới (_)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
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
                    CustomTextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      hintText: 'Mật khẩu',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mật khẩu không được để trống';
                        }
                        if (!isValidPassword(value)) {
                          return 'Mật khẩu phải dài ít nhất 8 ký tự và chứa ít nhất một chữ cái thường, chữ cái hoa, chữ số và ký tự đặc biệt (!@#\$&*~)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      hintText: 'Xác nhận mật khẩu',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mật khẩu không được để trống';
                        }
                        if (value != _passwordController.text) {
                          return 'Mật khẩu xác thực không khớp';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 43.h),
                    CustomButton(
                      text: 'Đăng ký',
                      width: 288.h,
                      height: 85.h,
                      color: const Color(0xFF00618A),
                      textStyle: TextStyles.filledButton,
                      borderRadius: 67.w,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<RegisterBloc>().add(
                                SubmitRegister(
                                    username: _usernameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    file: _selectedImage),
                              );
                        }
                      },
                    ),
                    SizedBox(height: 21.h),
                    buttonLoginGoogle(() {}),
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
}
