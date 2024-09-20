import 'package:flutter/material.dart';
import '../../../models/group_model.dart';
import '../../../models/expense_model.dart';
import '../../../config/text_styles.dart';
import 'widgets/expense_list_item.dart';
import 'package:intl/intl.dart'; // Thêm import này

class ExpenseListScreen extends StatelessWidget {
  final GroupModel groupModel;

  const ExpenseListScreen({Key? key, required this.groupModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildExpenseList(context, groupModel.expenses);
  }

  Widget _buildExpenseList(BuildContext context, List<ExpenseModel>? expenses) {
    if (expenses == null || expenses.isEmpty) {
      return Center(
          child: Text(
        'Chưa có chi tiêu nào',
        style: AppTextStyles.bodyBold.copyWith(color: Colors.white),
      ));
    }

    // Sắp xếp chi tiêu theo ngày, mới nhất lên đầu
    expenses.sort((a, b) => b.date.compareTo(a.date));

    // Nhóm chi tiêu theo ngày
    Map<String, List<ExpenseModel>> groupedExpenses = {};
    for (var expense in expenses) {
      String dateKey = DateFormat('yyyy-MM-dd').format(expense.date);
      groupedExpenses.putIfAbsent(dateKey, () => []).add(expense);
    }

    return ListView.builder(
      itemCount: groupedExpenses.length,
      itemBuilder: (context, index) {
        String dateKey = groupedExpenses.keys.elementAt(index);
        List<ExpenseModel> dayExpenses = groupedExpenses[dateKey]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat('EEEE, d MMMM, yyyy', 'vi_VN')
                    .format(DateTime.parse(dateKey)),
                style: AppTextStyles.bodyBold.copyWith(color: Colors.white),
              ),
            ),
            ...dayExpenses
                .map((expense) => ExpenseListItem(expense: expense))
                .toList(),
          ],
        );
      },
    );
  }
}
