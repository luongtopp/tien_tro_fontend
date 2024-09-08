import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'blocs/app_bloc_providers.dart';
import 'config/app_theme.dart';
import 'global.dart';
import 'repositories/app_repository_providers.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global.init();
  runApp(appRepositoryProviders(const MyApp()));
}

void setSlowAnimations() {
  timeDilation = 110;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    configureSystemUI(context);
    return appBlocProviders(
      context,
      ScreenUtilInit(
        designSize: const Size(430, 956),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Chia sẻ tiền sinh hoạt trọ',
            debugShowCheckedModeBanner: false,
            theme: appTheme(),
            onGenerateRoute: AppPages.onGenerateRoute,
          );
        },
      ),
    );
  }
}
