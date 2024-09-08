import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import '../group/group_screen.dart';
import 'home_screen.dart';
import 'menu_drawer.dart';

class ZoomDrawerScreen extends StatelessWidget {
  final UserModel user;
  final List<GroupModel> groups;

  const ZoomDrawerScreen({
    super.key,
    required this.user,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return groups.isNotEmpty
        ? ZoomDrawer(
            style: DrawerStyle.defaultStyle,
            mainScreen: HomeScreen(user: user),
            menuScreen: MenuDrawer(user: user, groups: groups),
            menuScreenWidth: 240.w,
            slideWidth: 430.w * 0.75,
            borderRadius: 30.r,
            showShadow: true,
            openCurve: Curves.linearToEaseOut,
            closeCurve: Curves.linearToEaseOut,
            mainScreenTapClose: true,
            angle: 0.0,
            menuBackgroundColor: const Color.fromARGB(255, 1, 67, 95),
          )
        : GroupScreen(user: user);
  }
}
