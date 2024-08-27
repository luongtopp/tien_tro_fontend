bool isValidEmail(String email) {
  final RegExp _emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  return _emailRegExp.hasMatch(email) &&
      !email.contains(' ') &&
      email.length <= 254;
}

bool isValidPassword(String password) {
  final RegExp _passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{8,}$');

  return password.length >= 8 && _passwordRegExp.hasMatch(password);
}

// Hàm để kiểm tra mật khẩu có chứa thông tin cá nhân không
bool isPasswordSecure(String password, String username, String email) {
  return !password.contains(username) &&
      !password.contains(email.split('@')[0]);
}

bool isValidUsername(String username) {
  final RegExp _usernameRegExp = RegExp(r'^[a-zA-Z0-9._]{3,30}$');

  return _usernameRegExp.hasMatch(username) &&
      !username.contains(' ') &&
      username.length >= 3 &&
      username.length <= 30;
}
