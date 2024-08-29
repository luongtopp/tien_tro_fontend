import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/login_bloc/login_blocs.dart';
import '../../blocs/login_bloc/login_events.dart';
import '../../config/text_styles.dart';
import '../../routes/app_route.dart';
import '../../widgets/dialogs/dialog_custom.dart';
import '../../widgets/drawer/drawer_widget.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                padding: EdgeInsets.only(left: 15.w, bottom: 15.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    accountHeader(
                        'https://firebasestorage.googleapis.com/v0/b/chia-se-tien-sinh-hoat-t-97a1b.appspot.com/o/avatars%2Fperson_money.png?alt=media&token=3e5be910-1f00-4278-aeba-36aca4af3928',
                        'Trần Đức Lương'),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.group_rounded,
                    color: AppColors.iconDrawerColor),
                title: const Text(
                  'Nhóm',
                  style: TextStyles.textItemDrawer,
                  maxLines: 1,
                ),
                trailing: const Icon(
                  Icons.add_rounded,
                  color: AppColors.iconDrawerColor,
                ),
                onTap: () {
                  showBottomSheetCustom(context);
                },
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 1, 110, 157),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 1, 86, 122),
                          blurRadius: 1,
                          spreadRadius: 2,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15)),
                  child: ListView.builder(
                    itemCount: 10, // Số lượng phần tử trong ListView
                    itemBuilder: (context, index) {
                      return Card(
                        color: index % 10 == 0
                            ? const Color.fromARGB(255, 70, 164, 185)
                            : Colors.white,
                        child: ListTile(
                          title: Text(
                            'One-line ListTile',
                            style: index % 10 == 0
                                ? TextStyles.textItemDrawer
                                : TextStyles.textItemDrawerNoSelected,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 90.h),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.iconDrawerColor,
                ),
                title: const Text(
                  'Đăng xuất',
                  style: TextStyles.textItemDrawer,
                ),
                onTap: () {
                  showDialogCustom(
                    context: context,
                    textTitle: 'Đăng xuất',
                    textContent: 'Bạn thực sự muốn đăng xuất khỏi ứng dụng?',
                    textAction: ['Đăng xuất', 'Hủy'],
                    action: [
                      () {
                        context.read<LoginBloc>().add(Logout());
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.LOGIN, (route) => false);
                      },
                      () {
                        Navigator.of(context).pop();
                      }
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
