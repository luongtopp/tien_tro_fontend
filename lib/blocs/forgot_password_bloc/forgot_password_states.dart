abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordValidating extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;
  ForgotPasswordFailure(this.error);
}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;
  ForgotPasswordError(this.error);
}

class ForgotPasswordNotification extends ForgotPasswordState {
  final String notificationMessage;
  ForgotPasswordNotification(this.notificationMessage);
}
