import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:chia_se_tien_sinh_hoat_tro/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'global.dart';
import 'routes/route_generator.dart';

void main() async {
  Global.init();
  runApp(const MyApp());
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
      providers: [...AppPages.allBlocProvider(context)],
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
