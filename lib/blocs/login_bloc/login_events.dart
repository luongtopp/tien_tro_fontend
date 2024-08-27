abstract class LoginEvent {}

class SubmitLogin extends LoginEvent {
  final String email;
  final String password;
  SubmitLogin({
    required this.email,
    required this.password,
  });
}

class LoginWithGoogle extends LoginEvent {
  LoginWithGoogle();
}
