import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';

void showDialogCustom({
  required BuildContext context,
  required String textTitle,
  required String textContent,
  List<String> textAction = const <String>["Chấp nhận", "Hủy"],
  required List<void Function()> action,
  TextStyle? titleStyle,
  TextStyle? contentStyle,
  Color? dialogBackgroundColor,
  double? borderRadius,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: dialogBackgroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 30.w),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(15.w, 10.h, 10.w, 15.h),
          width: 276.w,
          height: 160.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  textTitle,
                  style: titleStyle ??
                      const TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  textContent,
                  textAlign: TextAlign.start,
                  style: contentStyle ??
                      const TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DialogButton(
                        onTap: action[0],
                        fillColor: false,
                        text: textAction[0],
                      ),
                      SizedBox(width: 30.w),
                      DialogButton(
                        onTap: action[1],
                        fillColor: true,
                        text: textAction[1],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

class DialogButton extends StatelessWidget {
  final void Function() onTap;
  final bool fillColor;
  final String text;

  const DialogButton({
    super.key,
    required this.onTap,
    required this.fillColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 105.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: fillColor ? AppColors.primaryColor : null,
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: fillColor ? Colors.white : AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
