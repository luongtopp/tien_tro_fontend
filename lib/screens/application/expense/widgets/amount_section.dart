import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/l10n.dart';
import '../../../../config/text_styles.dart';

class AmountSection extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController nameController;
  final VoidCallback onAmountTap;

  const AmountSection({
    Key? key,
    required this.amountController,
    required this.nameController,
    required this.onAmountTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
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
      controller: amountController,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      readOnly: true,
      onTap: onAmountTap,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: '0',
        hintStyle: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildNameTextField(S s) {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: s.enterExpenseName,
        hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      maxLines: 2,
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
