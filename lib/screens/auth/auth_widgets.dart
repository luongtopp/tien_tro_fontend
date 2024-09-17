import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/text_styles.dart';
import '../../generated/l10n.dart';

Widget buttonLoginGoogle(void Function() ontap, BuildContext context) {
  final s = S.of(context);
  return GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      ontap();
    },
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
          Text(
            s.loginWithGoogle,
            style: const TextStyle(
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
      style: AppTextStyles.textButton,
    ),
  );
}

Widget textButtonSignUp(
    void Function() ontap, String noAccountText, String signUpText) {
  return InkWell(
    onTap: () {
      HapticFeedback.mediumImpact();
      ontap();
    },
    child: Wrap(
      children: <Widget>[
        Text(
          noAccountText,
          style: const TextStyle(
            fontFamily: 'SFProDisplay',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF272727),
          ),
        ),
        Text(
          signUpText,
          style: const TextStyle(
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
