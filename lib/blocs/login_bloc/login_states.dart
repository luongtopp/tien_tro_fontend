abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginValidating extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  LoginSuccess(this.message);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}

class LoginNotification extends LoginState {
  final String notificationMessage;
  LoginNotification(this.notificationMessage);
}
