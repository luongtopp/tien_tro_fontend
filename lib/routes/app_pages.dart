import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/application/group/create_group_screen.dart';
import '../screens/application/group/group_screen.dart';
import '../screens/application/group/join_group_screen.dart';
import '../screens/application/home/zoom_drawer_screen.dart';
import '../services/storage_service.dart';
import 'app_route.dart';

class AppPages {
  static final StorageService _storageService = StorageService();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.INITIAL:
        return _handleInitialRoute(settings);
      case AppRoutes.LOGIN:
        return _buildRoute(settings, const LoginScreen());
      case AppRoutes.FORGOT_PASSWORD:
        return _buildRoute(settings, const ForgotPasswordScreen());
      case AppRoutes.REGISTER:
        return _buildRoute(settings, const RegisterScreen());
      case AppRoutes.ZOOM_DRAWER_SCREEN:
        final arguments = settings.arguments as List<dynamic>;
        final user = arguments[0] as UserModel;
        final groups = arguments[1] as List<GroupModel>;

        return _buildRoute(
            settings, ZoomDrawerScreen(user: user, groups: groups),
            transition: TransitionType.fade);
      case AppRoutes.GROUP_SCREEN:
        final user = settings.arguments as UserModel;
        return _buildRoute(settings, GroupScreen(user: user));
      case AppRoutes.CREATE_GROUP:
        final user = settings.arguments as UserModel;
        return _buildRoute(settings, CreateGroupScreen(user: user),
            transition: TransitionType.bottomToTop);
      case AppRoutes.JOIN_GROUP:
        final user = settings.arguments as UserModel;
        return _buildRoute(settings, JoinGroupScreen(user: user),
            transition: TransitionType.bottomToTop);
      default:
        return _buildRoute(
          settings,
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Route<dynamic> _handleInitialRoute(RouteSettings settings) {
    //   bool deviceFirstOpen = _storageService.getDeviceFirstOpen();
    //   if (deviceFirstOpen) {
    return _buildRoute(settings, const OnBoardingScreen(),
        transition: TransitionType.fade);
    //   } else {
    //     // Kiểm tra xem người dùng đã đăng nhập chưa
    //     bool isLoggedIn = _storageService.getIsLoggedIn();
    //     if (isLoggedIn) {
    //       UserModel? user = _storageService.getUser();
    //       if (user != null) {
    //         if (user.lastAccessedGroupId != null) {
    //           return _buildRoute(settings, ZoomDrawerScreen(user: user));
    //         } else {
    //           return _buildRoute(settings, GroupScreen(user: user));
    //         }
    //       }
    //     }
    //     // Nếu chưa đăng nhập, chuyển đến màn hình đăng nhập
    //     return _buildRoute(settings, const LoginScreen());
    //   }
  }

  static Route<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page, {
    TransitionType transition = TransitionType.defaultTransition,
  }) {
    switch (transition) {
      case TransitionType.fade:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case TransitionType.bottomToTop:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      case TransitionType.rightToLeft:
        return CupertinoPageRoute(builder: (_) => page, settings: settings);
      case TransitionType.defaultTransition:
      default:
        return MaterialPageRoute(builder: (_) => page, settings: settings);
    }
  }
}

enum TransitionType {
  defaultTransition,
  fade,
  bottomToTop,
  rightToLeft,
}
