import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/text_styles.dart';

Widget buttonLoginGoogle(void Function() ontap) {
  return GestureDetector(
    onTap: ontap,
    child: SizedBox(
      width: 333.w,
      height: 85.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 45.w,
            height: 45,
            child: SvgPicture.asset('assets/icons/google.svg'),
          ),
          SizedBox(width: 15.w),
          const Text(
            'Đăng nhập với Google',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF474747),
            ),
          )
        ],
      ),
    ),
  );
}

Widget textButton({
  required String text,
  required void Function() onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Text(
      text,
      style: TextStyles.textButton,
    ),
  );
}

Widget textButtonSignUp(void Function() ontap) {
  return InkWell(
    onTap: ontap,
    child: const Wrap(
      children: [
        Text(
          'Bạn chưa có tài khoản? ',
          style: TextStyle(
            fontFamily: 'SFProDisplay',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF272727),
          ),
        ),
        Text(
          'Đăng ký',
          style: TextStyle(
            fontFamily: 'SFProDisplay',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF00618A),
          ),
        ),
      ],
    ),
  );
}
