import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'app_color.dart';

void configureSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

ThemeData appTheme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: AppColors.selectionColor,
      selectionHandleColor: AppColors.primaryColor,
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: AppColors.primaryColor,
    ),
  );
}
