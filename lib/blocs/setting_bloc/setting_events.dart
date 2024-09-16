import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class ToggleNotification extends SettingEvent {
  final bool isEnabled;

  const ToggleNotification(this.isEnabled);

  @override
  List<Object> get props => [isEnabled];
}

class ChangeLanguage extends SettingEvent {
  final Locale locale;

  const ChangeLanguage(this.locale);

  @override
  List<Object> get props => [locale];
}

class LoadSettings extends SettingEvent {}
