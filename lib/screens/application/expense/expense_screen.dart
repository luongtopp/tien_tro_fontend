import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../blocs/group_bloc/group_blocs.dart';
import '../../../blocs/group_bloc/group_events.dart';
import '../../../config/app_color.dart';
import '../../../generated/l10n.dart';
import '../../../models/expense_model.dart';
import '../../../models/group_model.dart';
import '../../../models/member_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/keyboard_calculator.dart';
import '../../../utils/snackbar_utils.dart';
import 'widgets/amount_section.dart';
import 'widgets/custom_appbar.dart';
import 'widgets/expense_for_section.dart';
import 'widgets/note_section.dart';

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
  final ScrollController _expenseForScrollController = ScrollController();
  List<MemberModel> members = [];
  List<MemberModel> _selectedMembers = [];
  double _totalAmount = 0;
  Map<String, double> _memberAmounts = {};
  List<ExpenseMember> _byPeople = [];
  List<ExpenseMember> _forPeople = [];

  // Thêm biến mới để theo dõi các thay đổi
  Map<String, double> _memberAmountChanges = {};

  // Thêm biến để theo dõi các thành viên đã chỉnh sửa
  Set<String> _editedMemberIds = {};

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
    _expenseForScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CustomAppBar(
        title: s.expense,
        onAddPressed: () => _validateAndSaveExpense(s),
      ),
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

  Widget _buildMainUI(S s) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 15.h),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            AmountSection(
              amountController: _amountController,
              nameController: _nameController,
              onAmountTap: _showCalculator,
            ),
            SizedBox(height: 15.h),
            ExpenseForSection(
              selectedMembers: _selectedMembers,
              memberAmounts: _memberAmounts,
              onMemberSelectionTap: _showMemberSelectionDialog,
              onMemberRemove: _removeMember,
              onMemberAmountEdit: _showEditAmountDialog,
            ),
            SizedBox(height: 15.h),
            NoteSection(
              noteController: _noteController,
              noteScrollController: _noteScrollController,
            ),
          ],
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

    if (_selectedMembers.isEmpty) {
      showCustomSnackBar(context, s.expenseForRequiredError,
          type: SnackBarType.error);
      return;
    }

    // Kiểm tra tổng số tiền của các thành viên
    double totalMemberAmount = _memberAmounts.values.reduce((a, b) => a + b);
    if ((totalMemberAmount - _totalAmount).abs() > 0.01) {
      showCustomSnackBar(context,
          'Tổng số tiền c��a các thành viên (${_formatAmount(totalMemberAmount)}) không khớp với chi tiêu (${_formatAmount(_totalAmount)})',
          type: SnackBarType.error);
      return;
    }

    // Nếu tất cả đều hợp lệ, lưu chi tiêu
    _saveExpense();
  }

  void _saveExpense() {
    final expense = ExpenseModel(
      isPaid: false,
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
    _editedMemberIds.clear(); // Reset edited list when total amount changes
    _redistributeAmount(); // Phân bổ lại khi tổng số tiền thay đổi
  }

  void _updateMemberAmountsBasedOnTotal() {
    if (_selectedMembers.isEmpty) return;
    double equalShare = _totalAmount / _selectedMembers.length;
    for (var member in _selectedMembers) {
      _memberAmounts[member.id] = equalShare;
    }
  }

  void _showMemberSelectionDialog() {
    final S s = S.of(context);
    List<MemberModel> tempSelectedMembers = List.from(_selectedMembers);

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
                        value: tempSelectedMembers.contains(member),
                        activeColor: AppColors.primaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              tempSelectedMembers.add(member);
                            } else {
                              tempSelectedMembers.remove(member);
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
                _updateSelectedMembers(tempSelectedMembers);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateSelectedMembers(List<MemberModel> newSelectedMembers) {
    setState(() {
      for (var member in members) {
        if (newSelectedMembers.contains(member) &&
            !_selectedMembers.contains(member)) {
          _addMember(member);
        } else if (!newSelectedMembers.contains(member) &&
            _selectedMembers.contains(member)) {
          _removeMember(member);
        }
      }
    });
  }

  void _removeMember(MemberModel member) {
    setState(() {
      _selectedMembers.remove(member);
      _memberAmounts.remove(member.id);
      _editedMemberIds.remove(member.id);
      _redistributeAmount();
    });
  }

  void _addMember(MemberModel member) {
    setState(() {
      _selectedMembers.add(member);
      _redistributeAmount();
    });
  }

  void _redistributeAmount() {
    if (_selectedMembers.isEmpty) {
      _memberAmounts.clear();
      _editedMemberIds.clear();
      return;
    }

    // Tính tổng số tiền đã được chỉnh sửa
    double editedTotal = _editedMemberIds.fold(
        0.0, (sum, id) => sum + (_memberAmounts[id] ?? 0));

    // Tính số tiền còn lại cần phân bổ
    double remainingAmount = _totalAmount - editedTotal;

    // Đếm số thành viên chưa được chỉnh sửa
    int unEditedCount = _selectedMembers.length - _editedMemberIds.length;

    if (unEditedCount > 0) {
      double equalShare = remainingAmount / unEditedCount;

      for (var member in _selectedMembers) {
        if (!_editedMemberIds.contains(member.id)) {
          _memberAmounts[member.id] = equalShare;
        }
      }
    }

    // Xử lý số dư do làm tròn
    double totalDistributed = _memberAmounts.values.reduce((a, b) => a + b);
    double remainder = _totalAmount - totalDistributed;
    if (remainder.abs() > 0.01) {
      String firstUnEditedMemberId = _selectedMembers
          .firstWhere((m) => !_editedMemberIds.contains(m.id),
              orElse: () => _selectedMembers.first)
          .id;
      _memberAmounts[firstUnEditedMemberId] =
          (_memberAmounts[firstUnEditedMemberId] ?? 0) + remainder;
    }
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
    double originalAmount = _memberAmounts[editedMemberId] ?? 0;
    _memberAmounts[editedMemberId] = newAmount;
    _editedMemberIds.add(editedMemberId);

    _updateMemberAmountChanges(editedMemberId, originalAmount, newAmount);
    _redistributeAmount();

    // Kiểm tra tổng số tiền sau khi phân bổ lại
    double totalAfterRedistribution =
        _memberAmounts.values.reduce((a, b) => a + b);
    if ((totalAfterRedistribution - _totalAmount).abs() > 0.01) {
      showCustomSnackBar(context,
          'Cảnh báo: Tổng số tiền (${_formatAmount(totalAfterRedistribution)}) không khớp với chi tiêu (${_formatAmount(_totalAmount)})',
          type: SnackBarType.error);
    }

    setState(() {});
  }

  void _updateMemberAmountChanges(
      String memberId, double oldAmount, double newAmount) {
    double change = newAmount - oldAmount;
    if (change.abs() > 0.01) {
      _memberAmountChanges[memberId] =
          (_memberAmountChanges[memberId] ?? 0) + change;
    }
  }

  // Thêm phương thức để lấy danh sách thay đổi
  List<Map<String, dynamic>> getAmountChangesList() {
    return _memberAmountChanges.entries.map((entry) {
      String memberId = entry.key;
      double change = entry.value;
      String memberName =
          _selectedMembers.firstWhere((m) => m.id == memberId).name;
      return {
        'name': memberName,
        'amount': change,
      };
    }).toList();
  }

  // Thêm phương thức để reset danh sách chỉnh sửa
  void _resetEditedList() {
    _editedMemberIds.clear();
    _redistributeAmount();
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
