import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/keyboard_calculator.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final NumberFormat _formatter = NumberFormat('#,###', 'en_US');
  final ScrollController _noteScrollController = ScrollController();

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
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            _buildMainUI(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        "Chi tiêu",
        style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      actions: [
        _buildAddButton(),
      ],
    );
  }

  Widget _buildAddButton() {
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
          Navigator.of(context).pop();
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Thêm',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildMainUI() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      reverse: true,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildAmountSection(),
          SizedBox(height: 15.h),
          _buildExpenseForSection(),
          SizedBox(height: 15.h),
          _buildNoteSection(),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(AppLocalizations.of(context).amount),
          _buildAmountTextField(),
          _buildSectionTitle(AppLocalizations.of(context).expenseName),
          _buildNameTextField(),
        ],
      ),
    );
  }

  Widget _buildAmountTextField() {
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
          onPressed: _updateAmount,
        );
      },
    );
  }

  void _updateAmount(dynamic value) {
    if (value.isEmpty) {
      _amountController.text = '';
    } else if (value is num) {
      _amountController.text = _formatter.format(value);
    } else {
      final numValue = num.tryParse(value.toString());
      if (numValue != null) {
        _amountController.text = _formatter.format(numValue);
      }
    }
  }

  Widget _buildNameTextField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Nhập tên chi tiêu...',
        hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      textCapitalization: TextCapitalization.sentences,
      maxLines: 2,
    );
  }

  Widget _buildExpenseForSection() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Chi tiền cho'),
        ],
      ),
    );
  }

  Widget _buildNoteSection() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Ghi chú'),
          _buildNoteTextField(),
        ],
      ),
    );
  }

  Widget _buildNoteTextField() {
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
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Nhập ghi chú...',
              hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
}
