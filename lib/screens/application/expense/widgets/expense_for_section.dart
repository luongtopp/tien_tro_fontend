import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/member_model.dart';

class ExpenseForSection extends StatelessWidget {
  final List<MemberModel> selectedMembers;
  final Map<String, double> memberAmounts;
  final VoidCallback onMemberSelectionTap;
  final Function(MemberModel) onMemberRemove;
  final Function(MemberModel) onMemberAmountEdit;

  const ExpenseForSection({
    Key? key,
    required this.selectedMembers,
    required this.memberAmounts,
    required this.onMemberSelectionTap,
    required this.onMemberRemove,
    required this.onMemberAmountEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.expenseFor,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: onMemberSelectionTap,
                child: Row(
                  children: [
                    Text(
                      '${selectedMembers.length} ${s.people}',
                      style: const TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.blue),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: onMemberSelectionTap,
            icon: const Icon(Icons.add, color: Colors.blue),
            label:
                Text(s.addPerson, style: const TextStyle(color: Colors.blue)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.blue),
            ),
          ),
          const SizedBox(height: 10),
          _buildMemberList(s),
        ],
      ),
    );
  }

  Widget _buildMemberList(S s) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: selectedMembers.length,
        itemBuilder: (context, index) {
          final member = selectedMembers[index];
          return ListTile(
            leading: GestureDetector(
              onTap: () => onMemberRemove(member),
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: member.avatarUrl != null
                        ? NetworkImage(member.avatarUrl!)
                        : const AssetImage('assets/images/avatar_default.png')
                            as ImageProvider,
                    radius: 20,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            title: Text(member.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_formatAmount(memberAmounts[member.id] ?? 0)} đ',
                  style: TextStyle(color: Colors.orange),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  onPressed: () => onMemberAmountEdit(member),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  String _formatAmount(double amount) {
    return NumberFormat('#,###', 'vi_VN').format(amount.round());
  }
}
