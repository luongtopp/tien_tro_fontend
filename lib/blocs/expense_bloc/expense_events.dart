import 'package:equatable/equatable.dart';

import '../../models/expense_model.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final ExpenseModel expense;
  const AddExpense(this.expense);

  @override
  List<Object> get props => [expense];
}
