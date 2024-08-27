import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;

  final TextInputType keyboardType;
  final String? errorText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      validator: widget.validator,
      obscureText: widget.obscureText ? _isObscure : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF505050),
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        filled: true,
        fillColor: const Color(0xFFDCDCDC),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(
          fontSize: 20,
          color: Color(0xFF8D8D8D),
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: Icon(widget.prefixIcon, color: Colors.grey),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFF8D8D8D),
          fontWeight: FontWeight.normal,
        ),
        errorText: widget.errorText,
        errorMaxLines: 2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Color(0xFFCACACA),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Color(0xFF9E9E9E),
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Color(0xFFFF8181),
            width: 1.0,
          ),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : (_controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.cancel_sharp, color: Colors.grey),
                    onPressed: () {
                      _controller.clear();
                    },
                  )
                : null),
      ),
    );
  }
}
