import 'package:chia_se_tien_sinh_hoat_tro/blocs/onboarding_bloc/onboarding_blocs.dart';
import 'package:chia_se_tien_sinh_hoat_tro/blocs/login_bloc/login_blocs.dart';
import 'package:chia_se_tien_sinh_hoat_tro/blocs/register_bloc/register_blocs.dart';
import 'package:chia_se_tien_sinh_hoat_tro/blocs/forgot_password_bloc/forgot_password_blocs.dart';
import 'package:chia_se_tien_sinh_hoat_tro/screens/auth/forgot_password_screen.dart';
import 'package:chia_se_tien_sinh_hoat_tro/screens/auth/login_screen.dart';
import 'package:chia_se_tien_sinh_hoat_tro/screens/auth/register_screen.dart';
import 'package:chia_se_tien_sinh_hoat_tro/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import 'app_route.dart';

class AppPages {
  static List<PageEntity> routes() {
    return [
      PageEntity(
        route: AppRoutes.INITIAL,
        page: const OnBoardingScreen(),
        bloc: BlocProvider(
          create: (context) => OnBoardingBloc(),
        ),
      ),
      PageEntity(
        route: AppRoutes.LOGIN,
        page: const LoginScreen(),
        bloc: BlocProvider(
          create: (context) => LoginBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
            userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
        ),
      ),
      PageEntity(
        route: AppRoutes.FORGOT_PASSWORD,
        page: const ForgotPasswordScreen(),
        bloc: BlocProvider(
          create: (context) => ForgotPasswordBloc(),
        ),
      ),
      PageEntity(
        route: AppRoutes.REGISTER,
        page: const RegisterScreen(),
        bloc: BlocProvider(
          create: (context) => RegisterBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
            userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
        ),
      ),
    ];
  }

  static List<BlocProvider<dynamic>> allBlocProvider(BuildContext context) {
    return routes().map<BlocProvider<dynamic>>((bloc) => bloc.bloc).toList();
  }
}

class PageEntity {
  final String route;
  final Widget page;
  final BlocProvider<dynamic> bloc;

  PageEntity({
    required this.route,
    required this.page,
    required this.bloc,
  });
}
