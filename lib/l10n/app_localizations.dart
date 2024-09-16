import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode?.isEmpty ?? true
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get amount => Intl.message('Amount', name: 'amount');
  String get expenseName => Intl.message('Expense Name', name: 'expenseName');
  String get settings => Intl.message('Settings', name: 'settings');
  String get options => Intl.message('Options', name: 'options');
  String get notifications =>
      Intl.message('Notifications', name: 'notifications');
  String get language => Intl.message('Language', name: 'language');
  String get vietnamese => Intl.message('Vietnamese', name: 'vietnamese');
  String get english => Intl.message('English', name: 'english');
  String get logoutConfirmationTitle =>
      Intl.message('Logout Confirmation', name: 'logoutConfirmationTitle');
  String get logoutConfirmationMessage =>
      Intl.message('This action cannot be undone.',
          name: 'logoutConfirmationMessage');
  String get logout => Intl.message('Logout', name: 'logout');
  String get cancel => Intl.message('Cancel', name: 'cancel');
  String get termsOfService =>
      Intl.message('Terms of Service', name: 'termsOfService');
  String get privacyPolicy =>
      Intl.message('Privacy Policy', name: 'privacyPolicy');
  String get appVersion => Intl.message('App Version', name: 'appVersion');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
