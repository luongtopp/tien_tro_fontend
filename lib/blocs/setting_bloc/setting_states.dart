import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingState extends Equatable {
  final bool notificationsEnabled;
  final Locale currentLocale;

  const SettingState({
    this.notificationsEnabled = true,
    this.currentLocale = const Locale('vi'),
  });

  SettingState copyWith({
    bool? notificationsEnabled,
    Locale? currentLocale,
  }) {
    return SettingState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      currentLocale: currentLocale ?? this.currentLocale,
    );
  }

  @override
  List<Object> get props => [notificationsEnabled, currentLocale];
}
