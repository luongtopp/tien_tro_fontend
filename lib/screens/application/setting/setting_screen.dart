import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

import '../../../blocs/auth_bloc/auth_blocs.dart';
import '../../../blocs/auth_bloc/auth_events.dart';
import '../../../blocs/setting_bloc/setting_blocs.dart';
import '../../../blocs/setting_bloc/setting_events.dart';
import '../../../blocs/setting_bloc/setting_states.dart';
import '../../../config/app_color.dart';
import '../../../config/text_styles.dart';
import '../../../routes/app_route.dart';
import '../../../l10n/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(l10n.settings, style: AppTextStyles.titleLarge),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryColor),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              _buildSectionTitle(l10n.options),
              _buildSwitchTile(
                title: l10n.notifications,
                value: state.notificationsEnabled,
                onChanged: (value) =>
                    context.read<SettingBloc>().add(ToggleNotification(value)),
              ),
              _buildLanguageSelector(context, state, l10n),
              SizedBox(height: 24.h),
              _buildSectionTitle(l10n.settings),
              _buildListTile(
                title: l10n.termsOfService,
                icon: Icons.description_outlined,
                onTap: () {
                  // TODO: Navigate to Terms of Service screen
                },
              ),
              _buildListTile(
                title: l10n.privacyPolicy,
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  // TODO: Navigate to Privacy Policy screen
                },
              ),
              _buildListTile(
                title: l10n.appVersion,
                icon: Icons.info_outline,
                trailing: Text('1.0.0',
                    style:
                        AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
              ),
              SizedBox(height: 32.h),
              _buildButton(l10n.logout, () {
                HapticFeedback.mediumImpact();
                _showLogoutDialog(context);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(title,
          style:
              AppTextStyles.titleLarge.copyWith(color: AppColors.primaryColor)),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: AppTextStyles.bodyLarge),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryColor,
    );
  }

  Widget _buildLanguageSelector(
      BuildContext context, SettingState state, AppLocalizations l10n) {
    return ListTile(
      title: Text(l10n.language, style: AppTextStyles.bodyLarge),
      trailing: DropdownButton<Locale>(
        value: state.currentLocale,
        items: [
          DropdownMenuItem<Locale>(
            value: const Locale('vi'),
            child: Text(l10n.vietnamese),
          ),
          DropdownMenuItem<Locale>(
            value: const Locale('en'),
            child: Text(l10n.english),
          ),
        ],
        onChanged: (newLocale) {
          if (newLocale != null) {
            context.read<SettingBloc>().add(ChangeLanguage(newLocale));
          }
        },
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      title: Text(title, style: AppTextStyles.bodyBold),
      leading: Icon(icon, color: AppColors.primaryColor),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(title,
          style: AppTextStyles.bodyLarge.copyWith(color: Colors.white)),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(
            l10n.logoutConfirmationTitle,
            style: AppTextStyles.bodyMedium,
          ),
          message: Text(
            l10n.logoutConfirmationMessage,
            style: AppTextStyles.bodyMedium,
          ),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                _logout(context);
              },
              child: Text(l10n.logout),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(l10n.cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    l10n.logoutConfirmationTitle,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  title: Text(
                    l10n.logoutConfirmationMessage,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(l10n.logout, style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _logout(context);
                  },
                ),
                Divider(),
                ListTile(
                  title: Text(l10n.cancel, textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.LOGIN, (route) => false);
  }
}
