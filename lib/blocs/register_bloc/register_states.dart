abstract class RegisterState {}

class LoginInitial extends RegisterState {}

class RegisterValidating extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  RegisterSuccess(this.message);
}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}

class RegisterError extends RegisterState {
  final String error;
  RegisterError(this.error);
}

class RegisterNotification extends RegisterState {
  final String notificationMessage;
  RegisterNotification(this.notificationMessage);
}
