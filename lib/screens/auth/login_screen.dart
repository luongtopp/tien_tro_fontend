import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/auth_bloc/auth_blocs.dart';
import '../../blocs/auth_bloc/auth_events.dart';
import '../../blocs/auth_bloc/auth_states.dart';
import '../../config/app_color.dart';
import '../../config/text_styles.dart';
import '../../generated/l10n.dart';
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLoginState(BuildContext context, AuthState state) {
    switch (state) {
      case AuthLoading():
        LoadingOverlay.show(context);
        break;
      case AuthAuthenticated():
        LoadingOverlay.hide();
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.ZOOM_DRAWER_SCREEN,
          arguments: [state.user, state.groups],
        );
        break;
      case AuthError():
        LoadingOverlay.hide();
        showCustomSnackBar(context, state.message, type: SnackBarType.error);
        break;
      case AuthSuccess():
        LoadingOverlay.hide();
        break;
      case AuthCanceled():
        LoadingOverlay.hide();
        break;
      default:
        LoadingOverlay.hide();
        break;
    }
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text,
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: _handleLoginState,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 89.h),
                    _buildLogo(),
                    SizedBox(height: 51.h),
                    _buildEmailField(s),
                    SizedBox(height: 24.h),
                    _buildPasswordField(s),
                    SizedBox(height: 43.h),
                    _buildForgotPasswordButton(s),
                    SizedBox(height: 46.h),
                    _buildLoginButton(s),
                    SizedBox(height: 21.h),
                    _buildGoogleLoginButton(s),
                    SizedBox(height: 24.h),
                    _buildSignUpButton(s),
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

  Widget _buildLogo() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 238.w,
        height: 236.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(S s) {
    return CustomTextField(
      controller: _emailController,
      hintText: s.email,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.alternate_email_rounded,
      keyboardType: TextInputType.emailAddress,
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
      hintText: s.password,
      prefixIcon: Icons.lock,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return s.passwordCannotBeEmpty;
        }
        return null;
      },
    );
  }

  Widget _buildForgotPasswordButton(S s) {
    return Container(
      alignment: Alignment.centerRight,
      width: 333.w,
      child: textButton(
        text: s.forgotPassword,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.FORGOT_PASSWORD),
      ),
    );
  }

  Widget _buildLoginButton(S s) {
    return CustomButton(
      text: s.login,
      width: 288.h,
      height: 85.h,
      color: AppColors.primaryColor,
      textStyle: AppTextStyles.filledButton,
      borderRadius: 67.r,
      onTap: _submitLogin,
    );
  }

  Widget _buildGoogleLoginButton(S s) {
    return buttonLoginGoogle(() {
      context.read<AuthBloc>().add(LoginWithGoogleRequested());
    }, context);
  }

  Widget _buildSignUpButton(S s) {
    return textButtonSignUp(() {
      Navigator.of(context).pushNamed(AppRoutes.REGISTER);
    }, s.dontHaveAnAccount, s.signUp);
  }
}
