import 'package:chia_se_tien_sinh_hoat_tro/screens/auth/forgot_password_screen.dart';
import 'package:chia_se_tien_sinh_hoat_tro/screens/auth/login_screen.dart';
import 'package:chia_se_tien_sinh_hoat_tro/screens/auth/register_screen.dart';
import 'package:chia_se_tien_sinh_hoat_tro/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import '../screens/application/group/create_group_screen.dart';
import '../screens/application/group/group_screen.dart';
import '../screens/application/group/join_group_screen.dart';
import '../screens/application/home/zoom_drawer_screen.dart';
import 'app_route.dart';

class AppPages {
  static List<PageEntity> routes() {
    return [
      PageEntity(
        route: AppRoutes.INITIAL,
        page: const OnBoardingScreen(),
      ),
      PageEntity(
        route: AppRoutes.LOGIN,
        page: const LoginScreen(),
      ),
      PageEntity(
        route: AppRoutes.FORGOT_PASSWORD,
        page: const ForgotPasswordScreen(),
      ),
      PageEntity(
        route: AppRoutes.REGISTER,
        page: const RegisterScreen(),
      ),
      PageEntity(
        route: AppRoutes.ZOOM_DRAWER_SCREEN,
        page: const ZoomDrawerScreen(),
      ),
      PageEntity(
        route: AppRoutes.GROUP_SCREEN,
        page: const GroupScreen(),
      ),
      PageEntity(
        route: AppRoutes.CREATE_GROUP,
        page: const CreateGroupScreen(),
      ),
      PageEntity(
        route: AppRoutes.JOIN_GROUP,
        page: const JoinGroupScreen(),
      ),
    ];
  }
}

class PageEntity {
  final String route;
  final Widget page;

  PageEntity({
    required this.route,
    required this.page,
  });
}
