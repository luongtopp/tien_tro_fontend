import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../config/app_color.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../group/group_screen.dart';
import 'home_screen.dart';
import 'main_drawer.dart';

class ZoomDrawerScreen extends StatefulWidget {
  const ZoomDrawerScreen({super.key});

  @override
  State<ZoomDrawerScreen> createState() => _ZoomDrawerScreenState();
}

class _ZoomDrawerScreenState extends State<ZoomDrawerScreen> {
  GroupModel? group;
  UserModel? user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    final groups = args[0];
    final user = args[1];
    return groups.isNotEmpty
        ? ZoomDrawer(
            style: DrawerStyle.defaultStyle,
            mainScreen: HomeScreen(groups: groups),
            menuScreen: MainDrawer(
              groups: groups,
              user: user!,
            ),
            menuScreenWidth: 240.w,
            slideWidth: 430.w * 0.75.w,
            borderRadius: 30.r,
            showShadow: true,
            openCurve: Curves.linearToEaseOut,
            closeCurve: Curves.linearToEaseOut,
            mainScreenTapClose: true,
            angle: 0.0,
            menuBackgroundColor: AppColors.primaryColor,
          )
        : const GroupScreen();
  }
}
