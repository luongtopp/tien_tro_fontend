abstract class RegisterEvent {}

class SubmitRegister extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  SubmitRegister({
    required this.username,
    required this.email,
    required this.password,
  });
}
