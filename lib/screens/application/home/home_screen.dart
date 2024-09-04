import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../../blocs/group_bloc/group_bloc.dart';
import '../../../blocs/group_bloc/group_event.dart';
import '../../../blocs/group_bloc/group_state.dart';
import '../../../blocs/group_bloc/group_stream_bloc.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/utils.dart';
import '../../../widgets/appbars/custom_appbar.dart';
import '../group/group_detail_screen.dart';
import '../group/group_screen.dart';
import '../notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  HomeScreen({
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
  Widget build(BuildContext context) {
    final groupBloc = BlocProvider.of<GroupStreamBloc>(context);
    groupBloc.add(StreamGroup(widget.user.id));

    return BlocBuilder<GroupStreamBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupInitial || state is GroupValidating) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GroupError) {
          return Center(child: Text('Error: ${state.error}'));
        }

        if (state is GroupStreamLoaded) {
          return _buildMainUI(state.groupsModel.first);
        }

        return const Center(child: Text('No group data available'));
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
          title: group.name,
          func: () {
            ZoomDrawer.of(context)!.toggle();
          },
          funcOption: () {},
          backgroundColor: Colors.transparent,
        ),
        body: _buildBody(group),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBody(GroupModel groupModel) {
    switch (_selectedIndex) {
      case 0:
        return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                width: 400.w,
                height: 204.h,
                padding: EdgeInsets.only(
                  left: 15.w,
                  top: 30.h,
                  right: 15.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.w)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tổng chi", style: AppTextStyles.heading),
                    SizedBox(height: 10.h),
                    Text(formattedAmount(getTotalExpenseAmount(groupModel)),
                        style: AppTextStyles.heading),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.emoji_objects_rounded,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 1:
        return GroupScreen(user: widget.user);
      case 2:
        return NotificationScreen();
      case 3:
        return GroupDetailScreen();
      default:
        return Center(
          child: BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
            if (state is GroupActionResult) {
              return Text('Welcome to ${state.group!.name}!');
            } else {
              return Text('Không xác định');
            }
          }),
        );
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(color: AppColors.primaryColor),
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
              _selectedIndex == 0 ? Icons.group_rounded : Icons.group_outlined,
              color:
                  _selectedIndex == 0 ? AppColors.primaryColor : Colors.grey),
          label: 'Nhóm',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              _selectedIndex == 1
                  ? Icons.account_balance_wallet_rounded
                  : Icons.account_balance_wallet_outlined,
              color:
                  _selectedIndex == 1 ? AppColors.primaryColor : Colors.grey),
          label: 'Group',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              _selectedIndex == 2
                  ? Icons.notifications_rounded
                  : Icons.notifications_outlined,
              color:
                  _selectedIndex == 2 ? AppColors.primaryColor : Colors.grey),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              _selectedIndex == 3 ? Icons.info_rounded : Icons.info_outlined,
              color:
                  _selectedIndex == 3 ? AppColors.primaryColor : Colors.grey),
          label: 'Details',
        ),
      ],
    );
  }

  double getTotalExpenseAmount(GroupModel groupModel) {
    return groupModel.members
        .fold(0.0, (sum, member) => sum + member.totalExpenseAmount);
  }
}
