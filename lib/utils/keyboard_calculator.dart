import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

import 'snackbar_utils.dart';

class KeyboardCalculator extends StatefulWidget {
  final Function(String) onPressed;
  final String value;
  final double heightFactor; // Thêm thuộc tính mới

  const KeyboardCalculator({
    super.key,
    required this.onPressed,
    this.value = '',
    this.heightFactor = 0.7, // Giá trị mặc định là 0.7
  });

  @override
  State<KeyboardCalculator> createState() => _KeyboardCalculatorState();
}

class _KeyboardCalculatorState extends State<KeyboardCalculator> {
  late String _input;
  late String _result;
  bool _disableFunctionButtons = false;
  final NumberFormat _formatter = NumberFormat('#,###', 'en_US');
  final int _maxDigits = 8;
  String _errorMessage = '';
  bool _showCheck = true;
  @override
  void initState() {
    super.initState();
    _input = widget.value;
    _result = widget.value;
    if (widget.value.isEmpty) {
      _disableFunctionButtons = true;
    } else {}
  }

  // Hàm để định dạng số
  String _formatNumber(String input) {
    if (input.isEmpty) return '';

    // Tách chuỗi thành các phần tử số và phép toán
    List<String> parts = input.split(RegExp(r'([-+×÷])'));
    List<String> operators =
        input.split(RegExp(r'[^-+×÷]')).where((e) => e.isNotEmpty).toList();

    String result = '';
    for (int i = 0; i < parts.length; i++) {
      String part = parts[i].trim();
      if (part.isNotEmpty) {
        try {
          if (part.contains('.')) {
            List<String> numberParts = part.split('.');
            result +=
                '${_formatter.format(int.parse(numberParts[0]))}.${numberParts[1]}';
          } else {
            result += _formatter.format(int.parse(part));
          }
        } catch (e) {
          result += part; // Giữ nguyên phần không phải số
        }
      }
      if (i < operators.length) {
        result += operators[i]; // Thêm phép toán vào kết quả
      }
    }
    return result;
  }

  void _handleButtonPress(String value) {
    try {
      setState(() {
        if (value == 'C') {
          _input = '';
          _result = '';
          _disableFunctionButtons = true;
          _errorMessage = '';
          _showCheck = true; // Reset về hiển thị check
        } else if (value == '=') {
          if (_showCheck) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          } else {
            // Nếu đang hiển thị =, tính toán kết quả
            _calculateResult();
            _input = _result;
            _disableFunctionButtons = false;
            // widget.onPressed(_result);
            _showCheck = true; // Chuyển sang hiển thị check
          }
          return;
        } else if (['+', '-', '×', '÷', '(', ')'].contains(value)) {
          _showCheck = false;

          if (_input.isNotEmpty || ['(', ')'].contains(value)) {
            // Kiểm tra ký tự cuối cùng của _input
            String lastChar =
                _input.isNotEmpty ? _input[_input.length - 1] : '';

            // Nếu ký tự cuối cùng không phải là toán tử, hoặc nếu đang thêm dấu ngoặc, thì thêm toán tử mới
            if (!['÷', '×', '+', '-'].contains(lastChar) ||
                ['(', ')'].contains(value)) {
              if (_result.isNotEmpty && _input == _result) {
                _input = _result + value;
              } else {
                _input += value;
              }
              _disableFunctionButtons = false;
              _errorMessage = '';
              _result = ''; // Reset _result để cho phép tính toán mới
            }
          }
        } else if (value == '.') {
          // Xử lý dấu thập phân
          if (!_input.contains('.')) {
            _input += _input.isEmpty ? '0.' : '.';
            _errorMessage = '';
          }
        } else {
          // Nếu _input đang chứa kết quả từ phép tính trước, bắt đầu một phép tính mới
          if (_result.isNotEmpty && _input == _result) {
            _input = value;
            _result = '';
          } else {
            // Kiểm tra số lượng chữ số trong số hiện tại
            List<String> parts = _input.split(RegExp(r'[-+×÷()]'));
            String currentNumber = parts.isNotEmpty ? parts.last : '';
            if (currentNumber.length < _maxDigits) {
              _input += value;
              _disableFunctionButtons = false;
              _errorMessage = '';
            } else {
              _errorMessage =
                  'Không thể nhập quá $_maxDigits chữ số cho một số!';
            }
          }
        }
      });
    } on FormatException catch (e) {
      showCustomSnackBar(context, e.message, type: SnackBarType.error);
    }
  }

  void _calculateResult() {
    // Kiểm tra nếu input chỉ chứa dấu ngoặc
    if (_input.trim().replaceAll(RegExp(r'[()]'), '').isEmpty) {
      throw const FormatException('Biểu thức không hợp lệ');
    }
    String expression = _input.replaceAll('×', '*').replaceAll('÷', '/');
    _result = eval(expression).toString();
    // Format the result
    if (_result.endsWith('.0')) {
      _result = _result.substring(0, _result.length - 2);
    }
  }

  dynamic eval(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result.round(); // Làm tròn đến số nguyên gần nhất
    } on Exception catch (e) {
      throw const FormatException('Biểu thức không hợp lệ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: MediaQuery.of(context).size.height *
          widget.heightFactor, // Sử dụng thuộc tính mới
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 15.h, bottom: 30.h),
            child: Container(
              width: 70.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      width: double.infinity,
                      constraints: BoxConstraints(maxHeight: 100.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 15.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  reverse: true,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: constraints.maxWidth),
                                    child: Text(
                                      _formatNumber(
                                          _result.isEmpty ? _input : _result),
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            icon:
                                Icon(Icons.backspace, color: Colors.grey[600]),
                            onPressed: () {
                              setState(() {
                                if (_input.isNotEmpty) {
                                  _input =
                                      _input.substring(0, _input.length - 1);
                                  _disableFunctionButtons = _input.isEmpty;
                                  _errorMessage = '';
                                  _result = ''; // Reset _result khi xóa
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SafeArea(
                      child: GridView.count(
                        crossAxisCount: 4,
                        childAspectRatio: 1.5,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        children: [
                          _buildButton('C', Colors.red, Colors.white),
                          _buildButton('(', Colors.orange, Colors.white),
                          _buildButton(')', Colors.orange, Colors.white),
                          _buildButton('÷', Colors.orange, Colors.white),
                          _buildButton('7', Colors.grey[300]!),
                          _buildButton('8', Colors.grey[300]!),
                          _buildButton('9', Colors.grey[300]!),
                          _buildButton('×', Colors.orange, Colors.white),
                          _buildButton('4', Colors.grey[300]!),
                          _buildButton('5', Colors.grey[300]!),
                          _buildButton('6', Colors.grey[300]!),
                          _buildButton('-', Colors.orange, Colors.white),
                          _buildButton('1', Colors.grey[300]!),
                          _buildButton('2', Colors.grey[300]!),
                          _buildButton('3', Colors.grey[300]!),
                          _buildButton('+', Colors.orange, Colors.white),
                          _buildButton('00', Colors.grey[300]!),
                          _buildButton('0', Colors.grey[300]!),
                          _buildButton('.', Colors.grey[300]!),
                          _buildButton('=', Colors.green, Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label,
      [Color color = Colors.white, Color textColor = Colors.black]) {
    bool isDisabled = _disableFunctionButtons &&
        [
          '+',
          '-',
          '×',
          '÷',
        ].contains(label);
    return SizedBox(
      width: 60.w,
      height: 60.h,
      child: Card(
        elevation: 1,
        color: isDisabled ? Colors.grey[400] : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: isDisabled
              ? null
              : () {
                  if (label == '=' && _showCheck) {
                    HapticFeedback.mediumImpact();
                    _handleButtonPress(label);
                    widget.onPressed(_input);
                  } else {
                    HapticFeedback.mediumImpact();
                    _handleButtonPress(label);
                  }
                },
          child: Center(
            child: label == '=' && _showCheck
                ? Icon(
                    _showCheck ? Icons.check_rounded : Icons.check,
                    color: isDisabled ? Colors.grey[600] : textColor,
                    size: 24,
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDisabled ? Colors.grey[600] : textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
