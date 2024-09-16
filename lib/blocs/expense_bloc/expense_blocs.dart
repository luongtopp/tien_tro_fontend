// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'expense_events.dart';
// import 'expense_states.dart';

// class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
//   final ExpenseRepository repository;

//   ExpenseBloc({required this.repository}) : super(ExpenseInitial()) {
//     on<LoadExpenses>(_onLoadExpenses);
//     on<AddExpense>(_onAddExpense);
//   }

//   void _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) async {
//     emit(ExpenseLoading());
//     try {
//       final expenses = await repository.getExpenses();
//       emit(ExpenseLoaded(expenses));
//     } catch (e) {
//       emit(ExpenseError(e.toString()));
//     }
//   }

//   void _onAddExpense(AddExpense event, Emitter<ExpenseState> emit) async {
//     final currentState = state;
//     if (currentState is ExpenseLoaded) {
//       try {
//         await repository.addExpense(event.expense);
//         final updatedExpenses = await repository.getExpenses();
//         emit(ExpenseLoaded(updatedExpenses));
//       } catch (e) {
//         emit(ExpenseError(e.toString()));
//       }
//     }
//   }
// }
