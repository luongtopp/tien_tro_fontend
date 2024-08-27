import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'blocs/forgot_password_bloc/forgot_password_blocs.dart';
import 'blocs/login_bloc/login_blocs.dart';
import 'blocs/onboarding_bloc/onboarding_blocs.dart';
import 'blocs/register_bloc/register_blocs.dart';
import 'config/app_color.dart';
import 'global.dart';
import 'repositories/auth_repository.dart';
import 'repositories/user_repository.dart';
import 'routes/route_generator.dart';

void main() async {
  Global.init();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

void setSlowAnimations() {
  timeDilation = 100;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return MultiBlocProvider(
      providers: [
        BlocProvider<OnBoardingBloc>(
          create: (context) => OnBoardingBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
            userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
            userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
        ),
        BlocProvider<ForgotPasswordBloc>(
          create: (context) => ForgotPasswordBloc(),
        ),
        // Thêm các BlocProvider khác nếu cần
      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 956),
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: AppColors.primaryColor,
              selectionColor: Color.fromARGB(255, 145, 189, 243),
              selectionHandleColor: AppColors.primaryColor,
            ),
            cupertinoOverrideTheme: const CupertinoThemeData(
              primaryColor: AppColors.primaryColor,
            ),
          ),
          onGenerateRoute: generateRouteSetting,
        ),
      ),
    );
  }
}
