import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter/services.dart'; // Add this import

import '../../../blocs/auth_bloc/auth_blocs.dart';
import '../../../blocs/auth_bloc/auth_events.dart';
import '../../../blocs/group_bloc/group_blocs.dart';
import '../../../blocs/group_bloc/group_events.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_route.dart';
import '../../../widgets/dialogs/dialog_custom.dart';
import '../../../widgets/drawer/drawer_widget.dart';

class MenuDrawer extends StatefulWidget {
  final UserModel user;
  final List<GroupModel> groups;
  const MenuDrawer({super.key, required this.user, required this.groups});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  late String selectedGroupId;

  @override
  void initState() {
    super.initState();
    selectedGroupId = widget.groups.isNotEmpty ? widget.groups[0].id! : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 67, 95),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDrawerHeader(),
              _buildGroupTile(),
              SizedBox(height: 8.h),
              Expanded(child: _buildGroupList()),
              SizedBox(height: 90.h),
              _buildLogoutTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      padding: EdgeInsets.only(left: 15.w, bottom: 15.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          accountHeader(
            widget.user.avatarUrl ??
                'https://firebasestorage.googleapis.com/v0/b/chia-se-tien-sinh-hoat-t-97a1b.appspot.com/o/avatars%2Fperson_money.png?alt=media&token=3e5be910-1f00-4278-aeba-36aca4af3928',
            widget.user.fullName,
          )
        ],
      ),
    );
  }

  Widget _buildGroupTile() {
    return Card(
      color: AppColors.primaryColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ListTile(
        leading:
            const Icon(Icons.group_rounded, color: AppColors.iconDrawerColor),
        title: Text('Nhóm', style: AppTextStyles.textItemDrawer, maxLines: 1),
        trailing:
            const Icon(Icons.add_rounded, color: AppColors.iconDrawerColor),
        onTap: () {
          HapticFeedback.mediumImpact();
          showBottomSheetCustom(context, onButtonTap: (value) {
            HapticFeedback.mediumImpact();
            if (value == 1) {
              Navigator.of(context)
                  .pushNamed(AppRoutes.CREATE_GROUP, arguments: widget.user);
            } else if (value == 2) {
              Navigator.of(context)
                  .pushNamed(AppRoutes.JOIN_GROUP, arguments: widget.user);
            }
          });
        },
      ),
    );
  }

  Widget _buildGroupList() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 1, 59, 84),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        margin: EdgeInsets.all(2),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 1, 59, 84),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
            BoxShadow(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                spreadRadius: -2,
                blurRadius: 5,
                offset: Offset(0, 0),
                blurStyle: BlurStyle.inner),
          ],
        ),
        child: ListView.builder(
          itemCount: widget.groups.length,
          itemBuilder: (context, index) =>
              _buildGroupCard(widget.groups[index]),
        ),
      ),
    );
  }

  Widget _buildGroupCard(GroupModel group) {
    final isSelected = selectedGroupId == group.id;
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: isSelected
          ? AppColors.iconDrawerSelectedColor
          : AppColors.iconDrawerNoSelectedColor,
      child: ListTile(
        title: Text(
          group.name,
          style: isSelected
              ? AppTextStyles.textItemDrawerSelected
              : AppTextStyles.textItemDrawerNoSelected,
        ),
        onTap: () {
          HapticFeedback.mediumImpact();
          _onGroupTap(group.id!);
        },
      ),
    );
  }

  void _onGroupTap(String groupId) {
    setState(() => selectedGroupId = groupId);
    context.read<GroupBloc>().add(FindGroupById(groupId));
    ZoomDrawer.of(context)!.toggle();
  }

  Widget _buildLogoutTile() {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      leading:
          const Icon(Icons.logout_rounded, color: AppColors.iconDrawerColor),
      title: Text('Đăng xuất', style: AppTextStyles.textItemDrawer),
      onTap: () {
        HapticFeedback.mediumImpact();
        _showLogoutDialog();
      },
    );
  }

  void _showLogoutDialog() {
    HapticFeedback.mediumImpact();
    showDialogCustom(
      context: context,
      textTitle: 'Đăng xuất',
      textContent: 'Bạn thực sự muốn đăng xuất khỏi ứng dụng?',
      textAction: ['Đăng xuất', 'Hủy'],
      action: [
        () {
          HapticFeedback.mediumImpact();
          _logout();
        },
        () {
          HapticFeedback.mediumImpact();
          Navigator.of(context).pop();
        },
      ],
    );
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.LOGIN, (route) => false);
  }
}
