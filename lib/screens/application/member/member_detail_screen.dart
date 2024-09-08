import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chia_se_tien_sinh_hoat_tro/models/member_model.dart';

class MemberDetailScreen extends StatelessWidget {
  final MemberModel member;

  const MemberDetailScreen({Key? key, required this.member}) : super(key: key);

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
                    _buildInfoRow('Tên', member.name),
                    // _buildInfoRow('Email', member.email),
                    _buildInfoRow(
                        'Số dư', '${member.balance} VND', true, context),
                    // Add more member information here
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
                      HapticFeedback.mediumImpact();
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã sao chép số dư')),
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
