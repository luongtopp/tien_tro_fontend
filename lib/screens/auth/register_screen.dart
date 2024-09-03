import 'dart:io';

import 'package:chia_se_tien_sinh_hoat_tro/blocs/register_bloc/register_events.dart';
import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/login_bloc/login_blocs.dart';
import '../../blocs/login_bloc/login_events.dart';
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
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegisterState(BuildContext context, RegisterState state) {
    LoadingOverlay.hide();
    switch (state) {
      case RegisterValidating():
        LoadingOverlay.show(context);
      case RegisterSuccess():
        showCustomSnackBar(context, state.message, type: SnackBarType.success);
        Navigator.pop(context);
      case RegisterFailure():
        showCustomSnackBar(context, state.error, type: SnackBarType.failed);
      case RegisterError():
        showCustomSnackBar(context, state.error, type: SnackBarType.error);
      default:
    }
  }

  void _handleImagePicked(File? croppedFile) {
    setState(() {
      _selectedImage = croppedFile;
    });
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
            SubmitRegister(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              file: _selectedImage,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: _handleRegisterState,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: appBarCustom(context: context, title: 'Đăng ký'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    _buildImagePicker(),
                    SizedBox(height: 51.h),
                    _buildUsernameField(),
                    SizedBox(height: 24.h),
                    _buildEmailField(),
                    SizedBox(height: 24.h),
                    _buildPasswordField(),
                    SizedBox(height: 24.h),
                    _buildConfirmPasswordField(),
                    SizedBox(height: 43.h),
                    _buildRegisterButton(),
                    SizedBox(height: 21.h),
                    _buildGoogleLoginButton(),
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

  Widget _buildImagePicker() {
    return CustomImagePicker(
      size: 75,
      onImagePicked: () => pickImage(
        context: context,
        onImagePicked: _handleImagePicked,
      ),
      image: _selectedImage,
    );
  }

  Widget _buildUsernameField() {
    return CustomTextField(
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
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
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
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
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
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
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
    );
  }

  Widget _buildRegisterButton() {
    return CustomButton(
      text: 'Đăng ký',
      width: 288.h,
      height: 85.h,
      color: const Color(0xFF00618A),
      textStyle: AppTextStyles.filledButton,
      borderRadius: 67.r,
      onTap: _submitRegistration,
    );
  }

  Widget _buildGoogleLoginButton() {
    return buttonLoginGoogle(() {
      context.read<LoginBloc>().add(LoginWithGoogle());
    });
  }
}
