import 'dart:math';

import 'package:chia_se_tien_sinh_hoat_tro/blocs/group_bloc/group_blocs.dart';
import 'package:chia_se_tien_sinh_hoat_tro/blocs/group_bloc/group_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../blocs/expense_bloc/expense_events.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../generated/l10n.dart';
import '../../../models/expense_model.dart';
import '../../../models/group_model.dart';
import '../../../models/member_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/keyboard_calculator.dart';
import '../../../utils/snackbar_utils.dart';

class ExpenseScreen extends StatefulWidget {
  final UserModel userModel;
  final GroupModel groupModel;
  const ExpenseScreen(
      {super.key, required this.groupModel, required this.userModel});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final NumberFormat _formatter = NumberFormat('#,###', 'vi_VN');
  final ScrollController _noteScrollController = ScrollController();
  List<MemberModel> members = [];
  List<MemberModel> _selectedMembers = [];
  double _totalAmount = 0;
  Map<String, double> _memberAmounts = {};
  List<ExpenseMember> _byPeople = [];
  List<ExpenseMember> _forPeople = [];

  @override
  void initState() {
    super.initState();
    members = widget.groupModel.members;
    _selectedMembers = List.from(members); // Initially select all members
    _initializeMemberAmounts();
  }

  void _initializeMemberAmounts() {
    for (var member in _selectedMembers) {
      _memberAmounts[member.id] = _totalAmount / _selectedMembers.length;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _noteController.dispose();
    _noteScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: _buildAppBar(s),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            _buildMainUI(s),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  AppBar _buildAppBar(S s) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        s.expense,
        style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      actions: [
        _buildAddButton(s),
      ],
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

  Widget _buildAddButton(S s) {
    return Card(
      elevation: 0,
      color: Colors.green,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(right: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          _validateAndSaveExpense(s);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            s.add,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  void _validateAndSaveExpense(S s) {
    // Kiểm tra số tiền
    if (_totalAmount < 1000) {
      showCustomSnackBar(context, s.amountTooLowError,
          type: SnackBarType.error);
      return;
    }

    // Kiểm tra tên chi tiêu
    if (_nameController.text.trim().isEmpty) {
      showCustomSnackBar(context, s.expenseNameRequiredError,
          type: SnackBarType.error);
      return;
    }

    // Nếu tất cả đều hợp lệ, lưu chi tiêu
    _saveExpense();
  }

  void _saveExpense() {
    final expense = ExpenseModel(
      amount: _totalAmount,
      note: _noteController.text,
      photos: [],
      title: _nameController.text,
      createdDate: DateTime.now(),
      date: DateTime.now(),
      byPeople: ExpenseMember(
          avatarUrl: widget.userModel.avatarUrl,
          id: widget.userModel.id,
          name: widget.userModel.fullName,
          balance: _totalAmount),
      forPeople: _selectedMembers
          .map((member) => ExpenseMember(
              id: member.id,
              name: member.name,
              balance: _memberAmounts[member.id] ?? 0))
          .toList(),
      transactionType: 'expense',
      groupId: widget.groupModel.id!,
    );
    context.read<GroupBloc>().add(ExpenseAdded(expense));
    // Sau khi lưu xong, đóng màn hình
    Navigator.of(context).pop();
  }

  Widget _buildMainUI(S s) {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 15.h),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildAmountSection(s),
            SizedBox(height: 15.h),
            _buildExpenseForSection(s),
            SizedBox(height: 15.h),
            _buildNoteSection(s),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection(S s) {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(s.amount),
          _buildAmountTextField(s),
          _buildSectionTitle(s.expenseName),
          _buildNameTextField(s),
        ],
      ),
    );
  }

  Widget _buildAmountTextField(S s) {
    return TextField(
      controller: _amountController,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      readOnly: true,
      onTap: _showCalculator,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: '0',
        hintStyle: TextStyle(fontSize: 24),
      ),
    );
  }

  void _showCalculator() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final value = _amountController.text.replaceAll(',', '');
        return KeyboardCalculator(
          heightFactor: 0.6,
          value: value,
          onPressed: (String newValue) {
            setState(() {
              _updateAmount(newValue);
              _updateMemberAmountsBasedOnTotal();
            });
          },
        );
      },
    );
  }

  void _updateAmount(String value) {
    if (value.isEmpty) {
      _amountController.text = '';
      _totalAmount = 0;
    } else {
      _totalAmount = double.tryParse(value) ?? 0;
      _amountController.text = _formatAmount(_totalAmount);
    }
  }

  void _updateMemberAmountsBasedOnTotal() {
    if (_selectedMembers.isEmpty) return;
    double equalShare = _totalAmount / _selectedMembers.length;
    for (var member in _selectedMembers) {
      _memberAmounts[member.id] = equalShare;
    }
  }

  Widget _buildNameTextField(S s) {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: s.enterExpenseName,
        hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      textCapitalization: TextCapitalization.sentences,
      maxLines: 2,
    );
  }

  Widget _buildExpenseForSection(S s) {
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
                onTap: _showMemberSelectionDialog,
                child: Row(
                  children: [
                    Text(
                      '${_selectedMembers.length} ${s.people}',
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
            onPressed: _showMemberSelectionDialog,
            icon: const Icon(Icons.add, color: Colors.blue),
            label:
                Text(s.addPerson, style: const TextStyle(color: Colors.blue)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.blue),
            ),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300, // Adjust this value as needed
            ),
            child: Scrollbar(
              thickness: 6,
              radius: const Radius.circular(10),
              thumbVisibility: true,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _selectedMembers.length,
                itemBuilder: (context, index) {
                  final member = _selectedMembers[index];
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () => _removeMember(member),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: member.avatarUrl != null
                                ? NetworkImage(member.avatarUrl!)
                                : const AssetImage(
                                        'assets/images/avatar_default.png')
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
                          '${_formatAmount(_memberAmounts[member.id] ?? 0)} đ',
                          style: TextStyle(color: Colors.orange),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_rounded, size: 20),
                          onPressed: () => _showEditAmountDialog(member),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMemberSelectionDialog() {
    final S s = S.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(s.selectMembers,
              style: TextStyle(color: AppColors.primaryColor)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.maxFinite,
                height: 300,
                child: Scrollbar(
                  thickness: 6,
                  radius: Radius.circular(10),
                  thumbVisibility: true,
                  child: ListView(
                    children: members.map((MemberModel member) {
                      return CheckboxListTile(
                        title: Text(member.name),
                        value: _selectedMembers.contains(member),
                        activeColor: AppColors.primaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedMembers.add(member);
                            } else {
                              _selectedMembers.remove(member);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(s.cancel,
                  style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child:
                  Text(s.ok, style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () {
                _recalculateMemberAmounts();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _recalculateMemberAmounts() {
    if (_selectedMembers.isEmpty) {
      _totalAmount = 0;
      _amountController.text = '0';
      _memberAmounts.clear();
      return;
    }

    double equalShare = _totalAmount / _selectedMembers.length;
    for (var member in _selectedMembers) {
      _memberAmounts[member.id] = equalShare;
    }

    // Xử lý số dư do làm tròn
    double totalDistributed = _memberAmounts.values.reduce((a, b) => a + b);
    double remainder = _totalAmount - totalDistributed;
    if (remainder.abs() > 0.01) {
      _memberAmounts[_selectedMembers.first.id] =
          (_memberAmounts[_selectedMembers.first.id] ?? 0) + remainder;
    }

    setState(() {
      _amountController.text = _formatAmount(_totalAmount);
    });
  }

  void _removeMember(MemberModel member) {
    setState(() {
      double removedAmount = _memberAmounts[member.id] ?? 0;
      _selectedMembers.remove(member);
      _memberAmounts.remove(member.id);

      if (_selectedMembers.isNotEmpty) {
        // Phân bổ lại số tiền của thành viên bị xóa cho các thành viên còn lại
        double amountPerMember = removedAmount / _selectedMembers.length;
        for (var remainingMember in _selectedMembers) {
          _memberAmounts[remainingMember.id] =
              (_memberAmounts[remainingMember.id] ?? 0) + amountPerMember;
        }

        // Xử lý số dư do làm tròn
        double totalDistributed = _memberAmounts.values.reduce((a, b) => a + b);
        double remainder = _totalAmount - totalDistributed;
        if (remainder.abs() > 0.01) {
          _memberAmounts[_selectedMembers.first.id] =
              (_memberAmounts[_selectedMembers.first.id] ?? 0) + remainder;
        }
      } else {
        // Nếu không còn thành viên nào, đặt tổng số tiền về 0
        _totalAmount = 0;
        _amountController.text = '0';
      }

      // Cập nhật UI
      _amountController.text = _formatAmount(_totalAmount);
    });
  }

  Widget _buildNoteSection(S s) {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(s.note),
          _buildNoteTextField(s),
        ],
      ),
    );
  }

  Widget _buildNoteTextField(S s) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 5 * 24.0,
      ),
      child: Scrollbar(
        thumbVisibility: true,
        controller: _noteScrollController,
        child: SingleChildScrollView(
          controller: _noteScrollController,
          child: TextField(
            controller: _noteController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: s.enterNote,
              hintStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.grey[700],
      ),
    );
  }

  void _showEditAmountDialog(MemberModel member) {
    final S s = S.of(context);
    final TextEditingController controller = TextEditingController(
      text: _formatAmount(_memberAmounts[member.id] ?? 0),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            member.name,
            style: TextStyle(color: AppColors.primaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${s.totalExpense}: ${_formatAmount(_totalAmount)} đ',
                style: TextStyle(color: AppColors.primaryColor),
              ),
              SizedBox(height: 10),
              TextField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _AmountInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: s.amount,
                  suffixText: 'đ',
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(s.cancel,
                  style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child:
                  Text(s.save, style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () {
                final newAmount = _parseAmount(controller.text);
                if (newAmount > _totalAmount) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(s.warning,
                            style: TextStyle(color: AppColors.primaryColor)),
                        content: Text(s.amountExceedsTotalWarning,
                            style: TextStyle(color: Colors.black)),
                        actions: <Widget>[
                          TextButton(
                            child: Text(s.ok,
                                style:
                                    TextStyle(color: AppColors.primaryColor)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    _adjustMemberAmounts(member.id, newAmount);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _adjustMemberAmounts(String editedMemberId, double newAmount) {
    // Đảm bảo newAmount không vượt quá _totalAmount
    newAmount = min(newAmount, _totalAmount);

    // Tính toán tổng số tiền hiện tại và số tiền cần điều chỉnh
    double currentTotal = _memberAmounts.values.reduce((a, b) => a + b);
    double adjustmentAmount = newAmount - (_memberAmounts[editedMemberId] ?? 0);

    // Nếu không có sự thay đổi, không cần điều chỉnh
    if (adjustmentAmount.abs() < 0.01) return;

    // Cập nhật số tiền cho thành viên được chỉnh sửa
    _memberAmounts[editedMemberId] = newAmount;

    // Tìm các thành viên khác có thể điều chỉnh
    List<String> adjustableMembers = _selectedMembers
        .where((m) => m.id != editedMemberId && (_memberAmounts[m.id] ?? 0) > 0)
        .map((m) => m.id)
        .toList();

    // Nếu không có thành viên nào khác có thể điều chỉnh, thoát
    if (adjustableMembers.isEmpty) return;

    // Tính toán tổng số tiền có thể điều chỉnh
    double adjustableTotal = adjustableMembers
        .map((id) => _memberAmounts[id] ?? 0)
        .reduce((a, b) => a + b);

    // Điều chỉnh số tiền cho các thành viên khác
    for (String memberId in adjustableMembers) {
      double currentAmount = _memberAmounts[memberId] ?? 0;
      double proportion = currentAmount / adjustableTotal;
      double adjustment = -adjustmentAmount * proportion;
      _memberAmounts[memberId] = max(0, currentAmount + adjustment);
    }

    // Xử lý số dư còn lại do làm tròn
    double newTotal = _memberAmounts.values.reduce((a, b) => a + b);
    double remainingDifference = _totalAmount - newTotal;
    if (remainingDifference.abs() > 0.01) {
      // Phân bổ số dư cho thành viên có số tiền lớn nhất (ngoại trừ thành viên vừa được chỉnh sửa)
      String maxMemberId = adjustableMembers.reduce((a, b) =>
          (_memberAmounts[a] ?? 0) > (_memberAmounts[b] ?? 0) ? a : b);
      _memberAmounts[maxMemberId] =
          (_memberAmounts[maxMemberId] ?? 0) + remainingDifference;
    }

    // Cập nhật _totalAmount và _amountController
    _totalAmount = _memberAmounts.values.reduce((a, b) => a + b);
    _amountController.text = _formatAmount(_totalAmount);

    setState(() {}); // Cập nhật UI
  }

  String _formatAmount(double amount) {
    return _formatter.format(amount.round());
  }

  double _parseAmount(String input) {
    return double.tryParse(input.replaceAll(',', '')) ?? 0;
  }
}

class _AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final cleanText = newValue.text.replaceAll(',', '');
    final formattedText =
        NumberFormat('#,###', 'en_US').format(int.parse(cleanText));

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
