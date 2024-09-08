import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../models/group_model.dart';
import '../../../utils/utils.dart';
import '../member/member_detail_screen.dart';

class GroupManagementScreen extends StatefulWidget {
  final GroupModel groupModel;

  const GroupManagementScreen({
    super.key,
    required this.groupModel,
  });

  @override
  State<GroupManagementScreen> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAmountVisible = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          _buildTotalExpenseCard(),
          SizedBox(height: 20.h),
          _buildMemberListHeader(),
          SizedBox(height: 10.h),
          Expanded(
            child: _buildMemberList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalExpenseCard() {
    return Container(
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
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                iconSize: 20,
                icon: Icon(_isAmountVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded),
                onPressed: () {
                  setState(() {
                    _isAmountVisible = !_isAmountVisible;
                    HapticFeedback.mediumImpact();
                  });
                },
              ),
              _isAmountVisible
                  ? formattedAmount(getTotalExpenseAmount(),
                      isTotalExpense: true)
                  : Text(
                      '******',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
            ],
          ),
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
    );
  }

  Widget _buildMemberListHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Danh sách thành viên",
        style: AppTextStyles.heading.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildMemberList() {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.6),
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.2),
            Colors.transparent,
          ],
          stops: const [0.0, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.groupModel.members.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 100.h),
        itemBuilder: (context, index) {
          final member = widget.groupModel.members[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    member.avatarUrl ?? 'assets/images/default_avatar.png'),
                radius: 20.r,
              ),
              title: Text(member.name, style: AppTextStyles.body),
              subtitle: formattedAmount(member.balance),
              trailing: Text(
                member.role == 'owner' ? 'Trưởng nhóm' : 'Thành viên',
                style: AppTextStyles.body.copyWith(
                  color: member.role == 'owner'
                      ? AppColors.primaryColor
                      : Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberDetailScreen(member: member),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  double getTotalExpenseAmount() {
    return widget.groupModel.members
        .fold(0.0, (sum, member) => sum + member.totalExpenseAmount);
  }
}
