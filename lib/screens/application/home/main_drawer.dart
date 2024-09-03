import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../../blocs/group_bloc/group_bloc.dart';
import '../../../blocs/group_bloc/group_event.dart';
import '../../../blocs/group_bloc/group_state.dart';
import '../../../blocs/login_bloc/login_blocs.dart';
import '../../../blocs/login_bloc/login_events.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_route.dart';
import '../../../widgets/dialogs/dialog_custom.dart';
import '../../../widgets/drawer/drawer_widget.dart';

class MainDrawer extends StatefulWidget {
  final List<GroupModel> groups;
  final UserModel user;
  const MainDrawer({super.key, required this.groups, required this.user});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late String selectedGroupId;

  @override
  void initState() {
    super.initState();
    selectedGroupId = widget.user.lastAccessedGroupId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupSuccess) {}
      },
      child: Scaffold(
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
    return ListTile(
      leading:
          const Icon(Icons.group_rounded, color: AppColors.iconDrawerColor),
      title: Text('Nhóm', style: AppTextStyles.textItemDrawer, maxLines: 1),
      trailing: const Icon(Icons.add_rounded, color: AppColors.iconDrawerColor),
      onTap: () => showBottomSheetCustom(context, onButtonTap: (value) {
        if (value == 1) {
          print('create group');
          Navigator.of(context).pushNamed(AppRoutes.CREATE_GROUP);
        } else if (value == 2) {
          Navigator.of(context).pushNamed(AppRoutes.JOIN_GROUP);
        }
      }),
    );
  }

  Widget _buildGroupList() {
    return Container(
      // clipBehavior: Clip.antiAliasWithSaveLayer,
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
          // boxShadow: [
          //   // BoxShadow(
          //   //   color: Colors.black.withOpacity(0.3),
          //   //   spreadRadius: 1,
          //   //   blurRadius: 5,
          //   //   offset: Offset(0, 3),
          //   // ),
          //   BoxShadow(
          //       color:
          //           const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
          //       spreadRadius: -2,
          //       blurRadius: 5,
          //       offset: Offset(0, 0),
          //       blurStyle: BlurStyle.inner),
          // ],
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
        onTap: () => _onGroupTap(group.id!),
      ),
    );
  }

  void _onGroupTap(String groupId) {
    setState(() => selectedGroupId = groupId);
    context.read<GroupBloc>().add(GetGroupById(groupId: groupId));
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading:
          const Icon(Icons.logout_rounded, color: AppColors.iconDrawerColor),
      title: Text('Đăng xuất', style: AppTextStyles.textItemDrawer),
      onTap: _showLogoutDialog,
    );
  }

  void _showLogoutDialog() {
    showDialogCustom(
      context: context,
      textTitle: 'Đăng xuất',
      textContent: 'Bạn thực sự muốn đăng xuất khỏi ứng dụng?',
      textAction: ['Đăng xuất', 'Hủy'],
      action: [
        _logout,
        () => Navigator.of(context).pop(),
      ],
    );
  }

  void _logout() {
    context.read<LoginBloc>().add(Logout());
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.LOGIN, (route) => false);
  }
}
