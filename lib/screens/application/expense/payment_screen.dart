import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../blocs/group_bloc/group_blocs.dart';
import '../../../blocs/group_bloc/group_events.dart';
import '../../../config/app_color.dart';
import '../../../generated/l10n.dart';
import '../../../models/group_model.dart';
import '../../../models/member_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/snackbar_utils.dart';
import 'widgets/custom_appbar.dart';
import 'widgets/note_section.dart';

class PaymentScreen extends StatefulWidget {
  final UserModel userModel;
  final GroupModel groupModel;
  const PaymentScreen(
      {Key? key, required this.groupModel, required this.userModel})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _noteController = TextEditingController();
  final ScrollController _noteScrollController = ScrollController();
  final NumberFormat _formatter = NumberFormat('#,###', 'vi_VN');

  late List<PaymentTransaction> _transactions = [];
  List<PaymentTransaction> _selectedTransactions = [];
  double _totalAmount = 0;
  double _currentUserDebt = 0;

  @override
  void initState() {
    super.initState();
    _calculateTransactions();
  }

  void _calculateTransactions() {
    final currentUser = widget.groupModel.members
        .firstWhere((member) => member.id == widget.userModel.id);
    _currentUserDebt = currentUser.balance;

    if (_currentUserDebt >= 0) return; // User doesn't owe money

    final creditors = widget.groupModel.members
        .where((member) => member.balance > 0)
        .toList()
      ..sort((a, b) => b.balance.compareTo(a.balance));

    double remainingDebt = _currentUserDebt.abs();
    for (var creditor in creditors) {
      if (remainingDebt <= 0) break;
      double amount = min(remainingDebt, creditor.balance);
      _transactions.add(PaymentTransaction(
        amount: amount,
        receiverId: creditor.id,
      ));
      remainingDebt -= amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CustomAppBar(
        title: s.payment,
        onAddPressed:
            _currentUserDebt < 0 ? () => _validateAndSavePayment(s) : null,
      ),
      body: SafeArea(
        child: _buildMainUI(s),
      ),
    );
  }

  Widget _buildMainUI(S s) {
    if (_currentUserDebt >= 0) {
      return Center(
        child: Text(
          'Bạn không có khoản nợ nào cần thanh toán.',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildDebtInfo(s),
          SizedBox(height: 15.h),
          NoteSection(
            noteController: _noteController,
            noteScrollController: _noteScrollController,
          ),
        ],
      ),
    );
  }

  Widget _buildDebtInfo(S s) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.1), width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng số nợ: ${_formatAmount(_currentUserDebt.abs())}đ',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Các giao dịch cần thực hiện:',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.h),
            ..._transactions.map(_buildTransactionItem).toList(),
            SizedBox(height: 20.h),
            _buildTotalSelectedAmount(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(PaymentTransaction transaction) {
    final receiver = widget.groupModel.members.firstWhere(
      (member) => member.id == transaction.receiverId,
      orElse: () => MemberModel(
        id: transaction.receiverId,
        name: 'Unknown',
        totalExpenseAmount: 0,
        balance: 0,
        isIdentified: false,
        role: '',
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CheckboxListTile(
        title: Text(
          '${_formatAmount(transaction.amount)}đ',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16.r,
              backgroundImage: receiver.avatarUrl != null
                  ? NetworkImage(receiver.avatarUrl!)
                  : null,
              child: receiver.avatarUrl == null
                  ? Text(
                      receiver.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 8.w),
            Text(
              receiver.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        value: _selectedTransactions.contains(transaction),
        onChanged: (bool? value) => _toggleTransaction(transaction, value),
        activeColor: AppColors.primaryColor,
        checkColor: Colors.white,
        tileColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      ),
    );
  }

  Widget _buildTotalSelectedAmount() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tổng số tiền đã chọn:',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            '${_formatAmount(_totalAmount)}đ',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTransaction(PaymentTransaction transaction, bool? value) {
    setState(() {
      if (value == true) {
        _selectedTransactions.add(transaction);
      } else {
        _selectedTransactions.remove(transaction);
      }
      _updateTotalAmount();
    });
  }

  void _updateTotalAmount() {
    _totalAmount = _selectedTransactions.fold(
        0, (sum, transaction) => sum + transaction.amount);
  }

  void _validateAndSavePayment(S s) {
    if (_selectedTransactions.isEmpty) {
      showCustomSnackBar(
          context, 'Vui lòng chọn ít nhất một giao dịch để thanh toán',
          type: SnackBarType.error);
      return;
    }

    if (_totalAmount < 1000) {
      showCustomSnackBar(context, s.amountTooLowError,
          type: SnackBarType.error);
      return;
    }

    _savePayment();
  }

  void _savePayment() {
    List<PaymentTransaction> transactions = _selectedTransactions
        .map((transaction) => PaymentTransaction(
              receiverId: transaction.receiverId,
              amount: transaction.amount,
            ))
        .toList();

    context.read<GroupBloc>().add(ProcessPayment(
          groupId: widget.groupModel.id!,
          payerId: widget.userModel.id,
          transactions: transactions,
          note: _noteController.text,
        ));

    Navigator.of(context).pop();
  }

  String _formatAmount(double amount) {
    return _formatter.format(amount.round());
  }

  @override
  void dispose() {
    _noteController.dispose();
    _noteScrollController.dispose();
    super.dispose();
  }
}
