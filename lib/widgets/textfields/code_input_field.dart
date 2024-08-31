import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_color.dart';

class CodeInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;

  const CodeInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.previousFocusNode,
  }) : super(key: key);

  @override
  State<CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<CodeInputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              widget.controller.text.isEmpty &&
              widget.previousFocusNode != null) {
            widget.previousFocusNode!.requestFocus();
          }
        },
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2.0,
              ),
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty && widget.nextFocusNode != null) {
              widget.nextFocusNode!.requestFocus();
            }
          },
          onTap: () {
            // Đặt con trỏ về cuối văn bản khi người dùng nhấn vào trường nhập liệu
            widget.controller.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.controller.text.length),
            );
          },
        ),
      ),
    );
  }
}
