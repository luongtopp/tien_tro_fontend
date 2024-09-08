import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/group_model.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupModel groupModel;
  const GroupDetailScreen({super.key, required this.groupModel});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (BuildContext context) {
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 2,
            child: SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                        'Mã nhóm', widget.groupModel.code, true, context),
                    _buildInfoRow(
                        'Ngày tạo',
                        widget.groupModel.createdDate
                            .toLocal()
                            .toString()
                            .split(' ')[0]),
                    _buildInfoRow(
                        'Trưởng nhóm', widget.groupModel.creator.toString()),
                    _buildInfoRow('Số thành viên',
                        widget.groupModel.members.length.toString()),
                    _buildInfoRow(
                        'Mô tả',
                        widget.groupModel.description == ''
                            ? 'Chưa có mô tả'
                            : widget.groupModel.description),
                  ],
                ),
              ),
            ),
          );
        },
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
            child: Row(
              children: [
                Text(value),
                const SizedBox(width: 10),
                if (copyable && context != null)
                  IconButton(
                    icon: const Icon(Icons.copy_rounded),
                    onPressed: () {
                      HapticFeedback.mediumImpact(); // Thêm phản hồi haptic
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã sao chép mã nhóm')),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
