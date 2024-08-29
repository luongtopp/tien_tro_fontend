import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../blocs/group_bloc/group_bloc.dart';
import '../../blocs/group_bloc/group_state.dart';
import '../../config/app_color.dart';
import '../../routes/app_route.dart';
import '../../utils/loading_overlay.dart';
import '../../utils/snackbar_utils.dart';
import 'home_screen.dart';
import 'main_drawer.dart';

class ZoomDrawerScreen extends StatefulWidget {
  const ZoomDrawerScreen({super.key});

  @override
  State<ZoomDrawerScreen> createState() => _ZoomDrawerScreenState();
}

class _ZoomDrawerScreenState extends State<ZoomDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        switch (state) {
          case GroupValidating():
            LoadingOverlay.show(context);
            break;
          case UserHasNoGroups():
            Navigator.of(context).popAndPushNamed(AppRoutes.CREATE_GROUP);
            break;
          case GroupFailure():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.error, type: SnackBarType.failed);
          case GroupError():
            LoadingOverlay.hide();
            showCustomSnackBar(context, state.error, type: SnackBarType.error);
        }
      },
      child: ZoomDrawer(
        style: DrawerStyle.defaultStyle,
        mainScreen: const HomeScreen(),
        menuScreen: const MainDrawer(),
        menuScreenWidth: 240.w,
        slideWidth: 430.w * 0.75.w,
        borderRadius: 30.w,
        showShadow: true,
        openCurve: Curves.linearToEaseOut,
        closeCurve: Curves.linearToEaseOut,
        mainScreenTapClose: true,
        angle: 0.0,
        menuBackgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
