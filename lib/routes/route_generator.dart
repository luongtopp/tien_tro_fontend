import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../global.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../utils/ route_utils.dart';
import 'app_pages.dart';
import 'app_route.dart';

PageRoute<dynamic> generateRouteSetting(RouteSettings settings) {
  if (settings.name != null) {
    var result =
        AppPages.routes().where((element) => element.route == settings.name);

    if (result.isNotEmpty) {
      var pageEntity = result.first;
      // bool deviceFirstOpent = Global.storageService.getDeviceFirstOpen();

      // if (pageEntity.route == AppRoutes.INITIAL && deviceFirstOpent) {
      // if (isLoggedin) {
      //   if (joinedGroup) {
      //     return MaterialPageRoute(
      //       builder: (context) => pageEntity.page,
      //       settings: settings,
      //     );
      //   } else {
      //     return createCustomPageRoute(pageEntity.page);
      //   }
      // }
      // return createCustomPageRoute(pageEntity.page);
      // }
      return CupertinoPageRoute(
          builder: (_) => result.first.page, settings: settings);
      // return createCustomPageRoute(pageEntity.page);

      // Xử lý các route khác với các tùy chọn hiệu ứng chuyển động
      // if (settings.name == AppRoutes.CREATE_GROUP ||
      //     settings.name == AppRoutes.JOIN_GROUP) {
      //   return createCustomPageRoute(pageEntity.page,
      //       direction: SlideDirection.bottomToTop);
      // }

      // return CupertinoPageRoute(
      //   builder: (context) => pageEntity.page,
      //   settings: settings,
      // );
    }
  }
  return createCustomPageRoute(const OnBoardingScreen());
}
