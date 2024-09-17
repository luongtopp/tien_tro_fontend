import 'package:flutter/material.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_styles.dart';
import '../../../../models/expense_model.dart';
import '../../../../utils/utils.dart';

class ExpenseListItem extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseListItem({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: expense.byPeople.avatarUrl != null
              ? NetworkImage(expense.byPeople.avatarUrl!)
              : null,
          child: expense.byPeople.avatarUrl == null
              ? Text(expense.byPeople.name[0].toUpperCase())
              : null,
        ),
        title: Text(
          expense.title,
          style: AppTextStyles.bodyBold.copyWith(),
        ),
        subtitle: Text(
          'Paid by ${expense.byPeople.name}',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
        ),
        trailing: formattedAmount(expense.amount),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
