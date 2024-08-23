import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../global.dart';
import 'app_pages.dart';

PageRoute<dynamic> generateRouteSetting(RouteSettings settings) {
  if (settings.name != null) {
    var result =
        AppPages.routes().where((element) => element.route == settings.name);

    if (result.isNotEmpty) {
      var pageEntity = result.first;
      bool deviceFirstOpent = Global.storageService.getDeviceFirstOpen();

      if (pageEntity.route == AppRoutes.INITIAL && deviceFirstOpent) {
        bool isLoggedin = Global.storageService.getIsLogin();
        bool joinedGroup = Global.storageService.getJoinedGroup();

        if (isLoggedin) {
          if (joinedGroup) {
            return MaterialPageRoute(
              builder: (context) => pageEntity.page,
              settings: settings,
            );
          } else {
            return createCustomPageRoute(pageEntity.page);
          }
        }
        return createCustomPageRoute(pageEntity.page);
      }

      // Xử lý các route khác với các tùy chọn hiệu ứng chuyển động
      if (settings.name == AppRoutes.CREATE_GROUP ||
          settings.name == AppRoutes.JOIN_GROUP) {
        return createCustomPageRoute(pageEntity.page,
            direction: SlideDirection.bottomToTop);
      }

      return CupertinoPageRoute(
        builder: (context) => pageEntity.page,
        settings: settings,
      );
    }
  }

  return createCustomPageRoute(const OnBoardingScreen());
}
