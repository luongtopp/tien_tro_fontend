import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class SubmitRegister extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  final File? file;

  const SubmitRegister({
    required this.username,
    required this.email,
    required this.password,
    required this.file,
  });

  @override
  List<Object?> get props => [username, email, password, file];
}

class UpdateUserEvent extends RegisterEvent {
  final UserModel user;

  const UpdateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteUserEvent extends RegisterEvent {
  final String userId;

  const DeleteUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
