String mapErrorCodeToMessage(String errorCode) {
  switch (errorCode) {
    case 'email-already-in-use':
      return 'Email đã tồn tại.';
    case 'invalid-email':
      return 'Địa chỉ email không đúng định dạng.';
    case 'weak-password':
      return 'Mật khẩu quá yếu.';
    case 'operation-not-allowed':
      return 'Hoạt động này không được phép.';
    case 'user-disabled':
      return 'Tài khoản này đã bị vô hiệu hóa.';
    case 'invalid-credential':
      return 'Email hoặc mật khẩu không đúng';
    case 'email-not-verified':
      return 'Tài khoản chưa được xác thực';
    case 'user-not-found':
      return 'Tài khoản không tồn tại';
    case 'wrong-password':
      return 'Mật khẩu không đúng';
    case 'too-many-requests':
      return 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
    default:
      return 'Đã xảy ra lỗi: $errorCode';
  }
}
