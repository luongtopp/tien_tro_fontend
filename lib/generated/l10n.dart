// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message(
      'Options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `App Version`
  String get appVersion {
    return Intl.message(
      'App Version',
      name: 'appVersion',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get vietnamese {
    return Intl.message(
      'Vietnamese',
      name: 'vietnamese',
      desc: '',
      args: [],
    );
  }

  /// `Member List`
  String get memberList {
    return Intl.message(
      'Member List',
      name: 'memberList',
      desc: '',
      args: [],
    );
  }

  /// `Edit Group`
  String get editGroup {
    return Intl.message(
      'Edit Group',
      name: 'editGroup',
      desc: '',
      args: [],
    );
  }

  /// `Leave Group`
  String get leaveGroup {
    return Intl.message(
      'Leave Group',
      name: 'leaveGroup',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense`
  String get addExpense {
    return Intl.message(
      'Add Expense',
      name: 'addExpense',
      desc: '',
      args: [],
    );
  }

  /// `Pay Debt`
  String get payDebt {
    return Intl.message(
      'Pay Debt',
      name: 'payDebt',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get detail {
    return Intl.message(
      'Detail',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get group {
    return Intl.message(
      'Group',
      name: 'group',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get expense {
    return Intl.message(
      'Expense',
      name: 'expense',
      desc: '',
      args: [],
    );
  }

  /// `Debt`
  String get debt {
    return Intl.message(
      'Debt',
      name: 'debt',
      desc: '',
      args: [],
    );
  }

  /// `Member`
  String get member {
    return Intl.message(
      'Member',
      name: 'member',
      desc: '',
      args: [],
    );
  }

  /// `Add Member`
  String get addMember {
    return Intl.message(
      'Add Member',
      name: 'addMember',
      desc: '',
      args: [],
    );
  }

  /// `Delete Group`
  String get deleteGroup {
    return Intl.message(
      'Delete Group',
      name: 'deleteGroup',
      desc: '',
      args: [],
    );
  }

  /// `Select Member to Delete`
  String get selectMemberToDelete {
    return Intl.message(
      'Select Member to Delete',
      name: 'selectMemberToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Update Group`
  String get updateGroup {
    return Intl.message(
      'Update Group',
      name: 'updateGroup',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Description cannot exceed 100 characters`
  String get descriptionCannotExceed100Characters {
    return Intl.message(
      'Description cannot exceed 100 characters',
      name: 'descriptionCannotExceed100Characters',
      desc: '',
      args: [],
    );
  }

  /// `Group Name`
  String get groupName {
    return Intl.message(
      'Group Name',
      name: 'groupName',
      desc: '',
      args: [],
    );
  }

  /// `Group name cannot be empty`
  String get groupNameCannotBeEmpty {
    return Intl.message(
      'Group name cannot be empty',
      name: 'groupNameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Group Code`
  String get groupCode {
    return Intl.message(
      'Group Code',
      name: 'groupCode',
      desc: '',
      args: [],
    );
  }

  /// `Created Date`
  String get createdDate {
    return Intl.message(
      'Created Date',
      name: 'createdDate',
      desc: '',
      args: [],
    );
  }

  /// `Group Leader`
  String get groupLeader {
    return Intl.message(
      'Group Leader',
      name: 'groupLeader',
      desc: '',
      args: [],
    );
  }

  /// `Member Count`
  String get memberCount {
    return Intl.message(
      'Member Count',
      name: 'memberCount',
      desc: '',
      args: [],
    );
  }

  /// `No Description`
  String get noDescription {
    return Intl.message(
      'No Description',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copiedToClipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Enter Expense Name`
  String get enterExpenseName {
    return Intl.message(
      'Enter Expense Name',
      name: 'enterExpenseName',
      desc: '',
      args: [],
    );
  }

  /// `Expense For`
  String get expenseFor {
    return Intl.message(
      'Expense For',
      name: 'expenseFor',
      desc: '',
      args: [],
    );
  }

  /// `Enter Expense For`
  String get enterExpenseFor {
    return Intl.message(
      'Enter Expense For',
      name: 'enterExpenseFor',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Enter Note`
  String get enterNote {
    return Intl.message(
      'Enter Note',
      name: 'enterNote',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Expense Name`
  String get expenseName {
    return Intl.message(
      'Expense Name',
      name: 'expenseName',
      desc: '',
      args: [],
    );
  }

  /// `Create Group`
  String get createGroup {
    return Intl.message(
      'Create Group',
      name: 'createGroup',
      desc: '',
      args: [],
    );
  }

  /// `Create Group Success`
  String get createGroupSuccess {
    return Intl.message(
      'Create Group Success',
      name: 'createGroupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Create Group Failed`
  String get createGroupFailed {
    return Intl.message(
      'Create Group Failed',
      name: 'createGroupFailed',
      desc: '',
      args: [],
    );
  }

  /// `Group created successfully`
  String get createGroupSuccessMessage {
    return Intl.message(
      'Group created successfully',
      name: 'createGroupSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create group`
  String get createGroupErrorMessage {
    return Intl.message(
      'Failed to create group',
      name: 'createGroupErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Create Group`
  String get createGroupButtonTooltip {
    return Intl.message(
      'Create Group',
      name: 'createGroupButtonTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Join Group`
  String get joinGroup {
    return Intl.message(
      'Join Group',
      name: 'joinGroup',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to paste the code?`
  String get doYouWantToPasteTheCode {
    return Intl.message(
      'Do you want to paste the code?',
      name: 'doYouWantToPasteTheCode',
      desc: '',
      args: [],
    );
  }

  /// `Paste Code`
  String get pasteCode {
    return Intl.message(
      'Paste Code',
      name: 'pasteCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter Group Code`
  String get enterGroupCode {
    return Intl.message(
      'Enter Group Code',
      name: 'enterGroupCode',
      desc: '',
      args: [],
    );
  }

  /// `Group code cannot be empty`
  String get groupCodeCannotBeEmpty {
    return Intl.message(
      'Group code cannot be empty',
      name: 'groupCodeCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Login with Google`
  String get loginWithGoogle {
    return Intl.message(
      'Login with Google',
      name: 'loginWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `No account?`
  String get noAccount {
    return Intl.message(
      'No account?',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset password email sent`
  String get resetPasswordEmailSent {
    return Intl.message(
      'Reset password email sent',
      name: 'resetPasswordEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred: $1`
  String get errorOccurred {
    return Intl.message(
      'Error occurred: \$1',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get emailCannotBeEmpty {
    return Intl.message(
      'Email cannot be empty',
      name: 'emailCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get invalidEmailFormat {
    return Intl.message(
      'Invalid email format',
      name: 'invalidEmailFormat',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter New Password`
  String get enterNewPassword {
    return Intl.message(
      'Enter New Password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Confirm Password`
  String get enterConfirmPassword {
    return Intl.message(
      'Enter Confirm Password',
      name: 'enterConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get passwordCannotBeEmpty {
    return Intl.message(
      'Password cannot be empty',
      name: 'passwordCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password and confirm password do not match`
  String get passwordAndConfirmPasswordDoNotMatch {
    return Intl.message(
      'Password and confirm password do not match',
      name: 'passwordAndConfirmPasswordDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Enter password again`
  String get enterPasswordAgain {
    return Intl.message(
      'Enter password again',
      name: 'enterPasswordAgain',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successfully`
  String get passwordResetSuccess {
    return Intl.message(
      'Password reset successfully',
      name: 'passwordResetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Password reset failed`
  String get passwordResetFailed {
    return Intl.message(
      'Password reset failed',
      name: 'passwordResetFailed',
      desc: '',
      args: [],
    );
  }

  /// `Password has been reset successfully`
  String get passwordResetSuccessMessage {
    return Intl.message(
      'Password has been reset successfully',
      name: 'passwordResetSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to reset password`
  String get passwordResetErrorMessage {
    return Intl.message(
      'Failed to reset password',
      name: 'passwordResetErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get enterPassword {
    return Intl.message(
      'Enter Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Don''t have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Enter Username`
  String get enterUsername {
    return Intl.message(
      'Enter Username',
      name: 'enterUsername',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty`
  String get usernameCannotBeEmpty {
    return Intl.message(
      'Username cannot be empty',
      name: 'usernameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid username format`
  String get invalidUsernameFormat {
    return Intl.message(
      'Invalid username format',
      name: 'invalidUsernameFormat',
      desc: '',
      args: [],
    );
  }

  /// `Invalid password format`
  String get invalidPasswordFormat {
    return Intl.message(
      'Invalid password format',
      name: 'invalidPasswordFormat',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password cannot be empty`
  String get confirmPasswordCannotBeEmpty {
    return Intl.message(
      'Confirm password cannot be empty',
      name: 'confirmPasswordCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to SplitExpense`
  String get onboardingTitle1 {
    return Intl.message(
      'Welcome to SplitExpense',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Clear all bills`
  String get onboardingSubtitle2 {
    return Intl.message(
      'Clear all bills',
      name: 'onboardingSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Make life easier`
  String get onboardingTitle2 {
    return Intl.message(
      'Make life easier',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `An awesome app we share with you and everyone`
  String get onboardingSubtitle1 {
    return Intl.message(
      'An awesome app we share with you and everyone',
      name: 'onboardingSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Transparent bills`
  String get onboardingTitle3 {
    return Intl.message(
      'Transparent bills',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `The rent-sharing app helps you easily manage and divide rental costs in a transparent and fair manner`
  String get onboardingSubtitle3 {
    return Intl.message(
      'The rent-sharing app helps you easily manage and divide rental costs in a transparent and fair manner',
      name: 'onboardingSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Select Members`
  String get selectMembers {
    return Intl.message(
      'Select Members',
      name: 'selectMembers',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `See more`
  String get seeMore {
    return Intl.message(
      'See more',
      name: 'seeMore',
      desc: '',
      args: [],
    );
  }

  /// `Paid By`
  String get paidBy {
    return Intl.message(
      'Paid By',
      name: 'paidBy',
      desc: '',
      args: [],
    );
  }

  /// `people`
  String get people {
    return Intl.message(
      'people',
      name: 'people',
      desc: '',
      args: [],
    );
  }

  /// `Add Person`
  String get addPerson {
    return Intl.message(
      'Add Person',
      name: 'addPerson',
      desc: '',
      args: [],
    );
  }

  /// `Edit Amount For`
  String get editAmountFor {
    return Intl.message(
      'Edit Amount For',
      name: 'editAmountFor',
      desc: '',
      args: [],
    );
  }

  /// `The entered amount exceeds the total expense. Please enter a smaller amount.`
  String get amountExceedsTotalWarning {
    return Intl.message(
      'The entered amount exceeds the total expense. Please enter a smaller amount.',
      name: 'amountExceedsTotalWarning',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Total Expense`
  String get totalExpense {
    return Intl.message(
      'Total Expense',
      name: 'totalExpense',
      desc: '',
      args: [],
    );
  }

  /// `Amount must be greater than 1000`
  String get amountTooLowError {
    return Intl.message(
      'Amount must be greater than 1000',
      name: 'amountTooLowError',
      desc: '',
      args: [],
    );
  }

  /// `Expense name is required`
  String get expenseNameRequiredError {
    return Intl.message(
      'Expense name is required',
      name: 'expenseNameRequiredError',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
