import 'package:flutter/cupertino.dart';

class AppPages {
  static List<PageEntity> routes() {
    return [
      // PageEntity(
      //   route: AppRoutes.INITIAL,
      //   page: const OnBoardingScreen(),
      //   bloc: BlocProvider(
      //     create: (context) => OnBoardingBloc(),
      //   ),
      // ),
      // PageEntity(
      //   route: AppRoutes.SIGN_IN,
      //   page: const SignInScreen(),
      //   bloc: BlocProvider(
      //     create: (context) => SignInBloc(),
      //   ),
      // ),
      // PageEntity(
      //   route: AppRoutes.REGISTER,
      //   page: const RegisterScreen(),
      //   bloc: BlocProvider(
      //     create: (context) => RegisterBloc(),
      //   ),
      // ),
      // Thêm các PageEntity khác tại đây
    ];
  }
}

class PageEntity {
  String? route;
  Widget? page;
  dynamic? bloc;
  PageEntity({
    required this.route,
    required this.page,
    required this.bloc,
  });
}
