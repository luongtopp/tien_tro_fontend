import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogleRequested extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final File? imageFile;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    this.imageFile,
  });

  @override
  List<Object> get props => [email, password, name];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class LogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
