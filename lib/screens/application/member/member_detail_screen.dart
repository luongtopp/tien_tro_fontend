import 'package:flutter/material.dart';
import 'package:chia_se_tien_sinh_hoat_tro/models/member_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';

class MemberDetailScreen extends StatefulWidget {
  final MemberModel member;

  const MemberDetailScreen({super.key, required this.member});

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Builder(
            builder: (BuildContext context) {
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 2,
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Tên', widget.member.name),
                        // _buildInfoRow('Email', member.email),
                        _buildInfoRow('Số dư', '${widget.member.balance} VND',
                            true, context),
                        // const SizedBox(height: 16),
                        // const Text(
                        //   'Chi tiêu',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        // Expanded(
                        //   child: ListView.builder(
                        //     itemCount: widget.member.expenses?.length ?? 0,
                        //     itemBuilder: (context, index) {
                        //       final expense = widget.member.expenses![index];
                        //       return ListTile(
                        //         title: Text(expense.title),
                        //         subtitle: Text(expense.date.toString()),
                        //         trailing: Text(
                        //           '${expense.amount.toStringAsFixed(2)} VND',
                        //           style: TextStyle(
                        //             color: expense.amount < 0
                        //                 ? Colors.red
                        //                 : Colors.green,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        'Chi tiết thành viên',
        style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      toolbarHeight: 60,
      elevation: 0,
      flexibleSpace: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      [bool copyable = false, BuildContext? context]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
