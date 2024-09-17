import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'setting_events.dart';
import 'setting_states.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(const SettingState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleNotification>(_onToggleNotification);
    on<ChangeLanguage>(_onChangeLanguage);
    add(LoadSettings()); // Add this line
  }

  Future<void> _onLoadSettings(
      LoadSettings event, Emitter<SettingState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    final languageCode = prefs.getString('language_code') ?? 'vi';
    emit(state.copyWith(
      notificationsEnabled: notificationsEnabled,
      currentLocale: Locale(languageCode),
    ));
  }

  Future<void> _onToggleNotification(
      ToggleNotification event, Emitter<SettingState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', event.isEnabled);
    emit(state.copyWith(notificationsEnabled: event.isEnabled));
  }

  Future<void> _onChangeLanguage(
      ChangeLanguage event, Emitter<SettingState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', event.locale.languageCode);
    emit(state.copyWith(currentLocale: event.locale));
    add(LoadSettings()); // Add this line to reload settings after changing language
  }
}
