import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<GroupStreamBloc>().add(StreamGroup(widget.user.id));

    return BlocBuilder<GroupStreamBloc, GroupStreamState>(
      builder: (context, state) {
        if (state is GroupStreamLoaded) {
          return _buildMainUI(state.groupsModel.first);
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundColorLinear,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundColorLinear,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainUI(GroupModel group) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundColorLinear,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          backgroundColor: Colors.transparent,
          disableBlurOnScroll: true,
          disableBackdropFilter: true,
          iconColor: Colors.white,
          leadingIcon: Icons.menu_rounded,
          actionIcon: Icons.more_vert_rounded,
          title: group.name,
          titleStyle: AppTextStyles.titleStyle.copyWith(
            color: Colors.white,
          ),
          func: () {
            HapticFeedback.mediumImpact(); // Add this line
            ZoomDrawer.of(context)!.toggle();
          },
          funcOption: () {
            HapticFeedback.mediumImpact(); // Add this line
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel:
                  MaterialLocalizations.of(context).modalBarrierDismissLabel,
              barrierColor: Colors.black54,
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
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
          },
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              left: Dimensions.paddingMedium,
              right: Dimensions.paddingMedium,
              top: Dimensions.paddingMedium),
          child: _buildBody(group),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
          },
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bo góc cho nút
            ),
          ),
          child: Text('Nhấn vào tôi'),
        ),
      ),
    );
  }

  Widget _buildBody(GroupModel groupModel) {
    switch (_selectedIndex) {
      case 0:
        return GroupManagementScreen(
          groupModel: groupModel,
        );
      case 1:
        return const ExpenseScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return GroupDetailScreen(
          groupModel: groupModel,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        HapticFeedback.mediumImpact(); // Add this line
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
        HapticFeedback.mediumImpact(); // Add this line
        onTap();
      },
    );
  }
}
