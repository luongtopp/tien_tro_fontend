import 'package:chia_se_tien_sinh_hoat_tro/screens/application/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter/services.dart';

import '../../../blocs/group_bloc/group_blocs.dart';
import '../../../blocs/group_bloc/group_events.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../generated/l10n.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_route.dart';
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
    final s = S.of(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 67, 95),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDrawerHeader(),
              _buildGroupTile(s),
              SizedBox(height: 8.h),
              Expanded(child: _buildGroupList()),
              SizedBox(height: 90.h),
              _buildSettingsTile(s),
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

  Widget _buildGroupTile(S s) {
    return Card(
      color: AppColors.primaryColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ListTile(
        leading:
            const Icon(Icons.group_rounded, color: AppColors.iconDrawerColor),
        title: Text(s.group,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            maxLines: 1),
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
        margin: const EdgeInsets.all(2),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 1, 59, 84),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                spreadRadius: -2,
                blurRadius: 5,
                offset: const Offset(0, 0),
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

  Widget _buildSettingsTile(S s) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      leading: const Icon(Icons.settings, color: AppColors.iconDrawerColor),
      title: Text(s.settings,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettingScreen()));
      },
    );
  }
}
