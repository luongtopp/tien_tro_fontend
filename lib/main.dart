import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'blocs/app_bloc_providers.dart';
import 'blocs/auth_bloc/auth_blocs.dart';
import 'blocs/auth_bloc/auth_states.dart';
import 'blocs/setting_bloc/setting_blocs.dart';
import 'blocs/setting_bloc/setting_states.dart';
import 'config/app_theme.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'global.dart';
import 'repositories/app_repository_providers.dart';
import 'routes/app_pages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Global.init();
  runApp(appRepositoryProviders(const MyApp()));
  FlutterNativeSplash.remove();
}

void setSlowAnimations() {
  timeDilation = 110;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key _appKey = UniqueKey();

  void _resetApp() {
    setState(() {
      _appKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    configureSystemUI(context);
    return KeyedSubtree(
      key: _appKey,
      child: appBlocProviders(
        context,
        ScreenUtilInit(
          designSize: const Size(430, 956),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<SettingBloc, SettingState>(
              builder: (context, state) {
                return MaterialApp(
                  locale: state.currentLocale,
                  localeListResolutionCallback: (locales, supportedLocales) {
                    return state.currentLocale;
                  },
                  title: 'Chia sẻ tiền sinh hoạt trọ',
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  theme: appTheme(),
                  onGenerateRoute: AppPages.onGenerateRoute,
                  builder: (context, child) {
                    return BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthUnauthenticated) {
                          _resetApp();
                        }
                      },
                      child: child!,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
