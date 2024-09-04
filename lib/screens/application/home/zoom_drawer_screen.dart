import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../../blocs/group_bloc/group_bloc.dart';
import '../../../blocs/group_bloc/group_event.dart';
import '../../../blocs/group_bloc/group_state.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/loading_overlay.dart';
import '../../../utils/snackbar_utils.dart';
import '../group/group_screen.dart';
import 'home_screen.dart';
import 'main_drawer.dart';

class ZoomDrawerScreen extends StatefulWidget {
  const ZoomDrawerScreen({Key? key}) : super(key: key);

  @override
  State<ZoomDrawerScreen> createState() => _ZoomDrawerScreenState();
}

class _ZoomDrawerScreenState extends State<ZoomDrawerScreen> {
  UserModel? user;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeUser();
      _isInitialized = true;
    }
  }

  void _initializeUser() {
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    user = args[0];
    if (user!.lastAccessedGroupId != null) {
      context.read<GroupBloc>().add(StreamGroup(user!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return user!.lastAccessedGroupId != null
        ? ZoomDrawer(
            style: DrawerStyle.defaultStyle,
            mainScreen: HomeScreen(user: user!),
            menuScreen: MainDrawer(user: user!),
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
        : HomeScreen(user: user!);
  }
}
