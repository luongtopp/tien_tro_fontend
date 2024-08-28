import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'blocs/app_bloc_providers.dart';
import 'config/app_theme.dart';
import 'global.dart';
import 'repositories/app_repository_providers.dart';
import 'routes/route_generator.dart';

void main() async {
  Global.init();
  runApp(appRepositoryProviders(const MyApp()));
}

void setSlowAnimations() {
  timeDilation = 100;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    configureSystemUI();
    return appBlocProviders(
      context,
      ScreenUtilInit(
        designSize: const Size(430, 956),
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: appTheme(),
          onGenerateRoute: generateRouteSetting,
        ),
      ),
    );
  }
}
