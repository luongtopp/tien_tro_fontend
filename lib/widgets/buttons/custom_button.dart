import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.color,
    required this.textStyle,
    required this.borderRadius,
    this.isBorder = false,
    this.onTap,
  });
  final double width;
  final double height;
  final double borderRadius;
  final Color color;
  final TextStyle textStyle;
  final bool isBorder;
  final void Function()? onTap;
  final String text;
  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        HapticFeedback.mediumImpact();
      },
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: SizedBox(
        width: widget.width + 3.w,
        height: widget.height + 3.h,
        child: Stack(
          children: [
            AnimatedContainer(
              width: _isPressed ? widget.width + 3.w : widget.width,
              height: _isPressed ? widget.height + 3.h : widget.height,
              decoration: BoxDecoration(
                color:
                    !_isPressed ? widget.color : widget.color.withOpacity(0.7),
                border: widget.isBorder
                    ? Border.all(color: AppColors.primaryColor, width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(64, 0, 0, 0),
                    blurRadius: 1.w,
                  ),
                ],
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.borderRadius)),
              ),
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: Text(widget.text, style: widget.textStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setPressed(bool isPressed) {
    setState(() {
      _isPressed = isPressed;
    });
  }
}
