import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../../blocs/group_bloc/group_stream_blocs.dart';
import '../../../blocs/group_bloc/group_stream_events.dart';
import '../../../blocs/group_bloc/group_stream_states.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/appbars/custom_appbar.dart';
import '../expense/expense_screen.dart';
import '../group/edit_group_screen.dart';
import '../group/group_detail_screen.dart';
import '../group/group_management.dart';
import '../notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    context.read<GroupStreamBloc>().add(StreamGroup(widget.user.id));

    return BlocBuilder<GroupStreamBloc, GroupStreamState>(
      builder: (context, state) {
        return Container(
          decoration:
              const BoxDecoration(gradient: AppColors.backgroundColorLinear),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: state is GroupStreamLoaded
                ? _buildMainUI(state.groupsModel.first)
                : const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor)),
          ),
        );
      },
    );
  }

  Widget _buildMainUI(GroupModel group) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildCustomAppBar(group),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingMedium),
        child: _buildBody(group),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(group),
    );
  }

  CustomAppBar _buildCustomAppBar(GroupModel group) {
    return CustomAppBar(
      backgroundColor: Colors.transparent,
      disableBlurOnScroll: true,
      disableBackdropFilter: true,
      iconColor: Colors.white,
      leadingIcon: Icons.menu_rounded,
      actionIcon: Icons.more_vert_rounded,
      title: group.name,
      titleStyle: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      func: () {
        HapticFeedback.mediumImpact();
        ZoomDrawer.of(context)!.toggle();
      },
      funcOption: () => _showOptionsDialog(group),
    );
  }

  void _showOptionsDialog(GroupModel group) {
    HapticFeedback.mediumImpact();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          alignment: const Alignment(0.8, -0.8),
          child: Material(
            type: MaterialType.transparency,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: kToolbarHeight - 10.h,
                      right: Dimensions.paddingMedium),
                  child: _buildPopupMenuItems(context, group),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(GroupModel groupModel) {
    switch (_selectedIndex) {
      case 0:
        return GroupManagementScreen(groupModel: groupModel);
      case 1:
        return const ExpenseScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return GroupDetailScreen(groupModel: groupModel);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        HapticFeedback.mediumImpact();
        setState(() {
          _selectedIndex = index;
        });
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(color: AppColors.primaryColor),
      unselectedLabelStyle: const TextStyle(color: Colors.grey),
      items: [
        _buildBottomNavigationBarItem(
            0, Icons.group_rounded, Icons.group_outlined, 'Nhóm'),
        _buildBottomNavigationBarItem(1, Icons.account_balance_wallet_rounded,
            Icons.account_balance_wallet_outlined, 'Thu chi'),
        _buildBottomNavigationBarItem(2, Icons.notifications_rounded,
            Icons.notifications_outlined, 'Thông báo'),
        _buildBottomNavigationBarItem(
            3, Icons.info_rounded, Icons.info_outlined, 'Chi tiết'),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      int index, IconData selectedIcon, IconData unselectedIcon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(
        _selectedIndex == index ? selectedIcon : unselectedIcon,
        color: _selectedIndex == index ? AppColors.primaryColor : Colors.grey,
      ),
      label: label,
    );
  }

  Widget? _buildFloatingActionButton(GroupModel group) {
    if (_selectedIndex != 0 && _selectedIndex != 1) return null;
    return SpeedDial(
      onOpen: () {
        HapticFeedback.mediumImpact();
      },
      onClose: () {
        HapticFeedback.mediumImpact();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      icon: Icons.add_rounded,
      activeIcon: Icons.close_rounded,
      animatedIconTheme: const IconThemeData(size: 22.0),
      backgroundColor: const Color.fromARGB(255, 255, 172, 6),
      foregroundColor: Colors.white,
      activeForegroundColor: Colors.white,
      activeBackgroundColor: Colors.red,
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
      elevation: 0,
      visible: true,
      curve: Curves.linear,
      childMargin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      spacing: 15,
      children: [
        _buildSpeedDialChild(
          icon: Icons.add_shopping_cart_rounded,
          label: 'Thêm chi tiêu',
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExpenseScreen()),
            );
          },
        ),
        _buildSpeedDialChild(
          icon: Icons.payment_rounded,
          label: 'Trả nợ',
          color: Colors.green,
          onTap: () {/* Add new member */},
        ),
      ],
    );
  }

  SpeedDialChild _buildSpeedDialChild({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SpeedDialChild(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19.r)),
      child: Icon(icon, color: color),
      backgroundColor: Colors.white,
      onTap: onTap,
      label: label,
      labelStyle:
          const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
      labelBackgroundColor: color,
    );
  }

  Widget _buildPopupMenuItems(BuildContext context, GroupModel group) {
    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: const Color.fromARGB(184, 0, 0, 0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 100,
            offset: Offset(0, 0),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.user.id == group.ownerId) ...[
              _buildPopupMenuItem(
                icon: Icons.edit_rounded,
                title: 'Sửa nhóm',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditGroupScreen(group: group)),
                  );
                },
              ),
              _buildPopupMenuItem(
                icon: Icons.delete,
                title: 'Xóa nhóm',
                onTap: () {
                  // Implement delete group functionality
                  Navigator.of(context).pop();
                },
              ),
            ] else ...[
              _buildPopupMenuItem(
                icon: Icons.exit_to_app,
                title: 'Rời nhóm',
                onTap: () {
                  // Implement leave group functionality
                  Navigator.of(context).pop();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
    );
  }
}
