import '../../models/group_model.dart';
import '../../models/user_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginValidating extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  final List<GroupModel>? groups;
  final UserModel? user;
  LoginSuccess(this.message, this.groups, this.user);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}

class LoginOutSuccess extends LoginState {
  LoginOutSuccess();
}

class LoginNotification extends LoginState {
  final String notificationMessage;
  LoginNotification(this.notificationMessage);
}
