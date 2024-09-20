import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/auth_bloc/auth_blocs.dart';
import '../../blocs/auth_bloc/auth_events.dart';
import '../../blocs/auth_bloc/auth_states.dart';
import '../../config/app_color.dart';
import '../../config/text_styles.dart';
import '../../generated/l10n.dart';
import '../../utils/image_utils.dart';
import '../../utils/loading_overlay.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/validators.dart';
import '../../widgets/appbars/custom_appbar.dart';
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

  void _handleRegisterState(BuildContext context, AuthState state) {
    switch (state) {
      case AuthLoading():
        LoadingOverlay.show(context);
        break;
      case AuthSuccess():
        LoadingOverlay.hide();
        showCustomSnackBar(context, state.message, type: SnackBarType.success);
        Navigator.pop(context);
        break;
      default:
        LoadingOverlay.hide();
        break;
    }
  }

  void _handleImagePicked(File? croppedFile) {
    setState(() {
      _selectedImage = croppedFile;
    });
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterRequested(
              name: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              imageFile: _selectedImage,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: _handleRegisterState,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: s.register,
          leadingIcon: Icons.arrow_back_ios_new_rounded,
          iconColor: AppColors.primaryColor,
          func: () => Navigator.of(context).pop(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    _buildImagePicker(s),
                    SizedBox(height: 51.h),
                    _buildUsernameField(s),
                    SizedBox(height: 24.h),
                    _buildEmailField(s),
                    SizedBox(height: 24.h),
                    _buildPasswordField(s),
                    SizedBox(height: 24.h),
                    _buildConfirmPasswordField(s),
                    SizedBox(height: 43.h),
                    _buildRegisterButton(s),
                    SizedBox(height: 21.h),
                    _buildGoogleLoginButton(s),
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

  Widget _buildImagePicker(S s) {
    return CustomImagePicker(
      size: 75,
      onImagePicked: () => pickImage(
        context: context,
        onImagePicked: _handleImagePicked,
      ),
      image: _selectedImage,
    );
  }

  Widget _buildUsernameField(S s) {
    return CustomTextField(
      controller: _usernameController,
      hintText: s.username,
      prefixIcon: Icons.person_rounded,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return s.usernameCannotBeEmpty;
        }
        if (!isValidUsername(value)) {
          return s.invalidUsernameFormat;
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(S s) {
    return CustomTextField(
      controller: _emailController,
      hintText: s.email,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.alternate_email_rounded,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return s.emailCannotBeEmpty;
        }
        if (!isValidEmail(value)) {
          return s.invalidEmailFormat;
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(S s) {
    return CustomTextField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      hintText: s.password,
      prefixIcon: Icons.lock,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return s.passwordCannotBeEmpty;
        }
        if (!isValidPassword(value)) {
          return s.invalidPasswordFormat;
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(S s) {
    return CustomTextField(
      controller: _confirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      hintText: s.confirmPassword,
      prefixIcon: Icons.lock,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return s.confirmPasswordCannotBeEmpty;
        }
        if (value != _passwordController.text) {
          return s.passwordsDoNotMatch;
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton(S s) {
    return CustomButton(
      text: s.register,
      width: 288.h,
      height: 85.h,
      color: const Color(0xFF00618A),
      textStyle: AppTextStyles.filledButton,
      borderRadius: 67.r,
      onTap: _submitRegistration,
    );
  }

  Widget _buildGoogleLoginButton(S s) {
    return buttonLoginGoogle(() {
      context.read<AuthBloc>().add(LoginWithGoogleRequested());
    }, context);
  }
}
