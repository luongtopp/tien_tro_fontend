import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/group_model.dart';
import '../../../generated/l10n.dart'; // Thêm import này

class GroupDetailScreen extends StatefulWidget {
  final GroupModel groupModel;
  const GroupDetailScreen({super.key, required this.groupModel});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context); // Thêm dòng này
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
                        s.groupCode, widget.groupModel.code, true, context),
                    _buildInfoRow(
                        s.createdDate,
                        widget.groupModel.createdDate
                            .toLocal()
                            .toString()
                            .split(' ')[0]),
                    _buildInfoRow(
                        s.groupLeader, widget.groupModel.creator.toString()),
                    _buildInfoRow(s.memberCount,
                        widget.groupModel.members.length.toString()),
                    _buildInfoRow(
                        s.description,
                        widget.groupModel.description.isEmpty
                            ? s.noDescription
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
    final s = S.of(context ?? this.context); // Thêm dòng này
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
                      HapticFeedback.mediumImpact();
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(s.copiedToClipboard)),
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
