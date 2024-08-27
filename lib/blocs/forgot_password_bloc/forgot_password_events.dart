abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class SubmitForgotPassword extends ForgotPasswordEvent {
  final String email;
  SubmitForgotPassword(this.email);
}
