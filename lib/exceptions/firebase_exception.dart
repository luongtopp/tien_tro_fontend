import 'package:firebase_auth/firebase_auth.dart';

FirebaseException handleException(
    dynamic e, String defaultMessage, String plugin) {
  if (e is FirebaseException) {
    return FirebaseException(
      plugin: plugin,
      code: e.code,
      message: _translateFirebaseError(e.code) ?? defaultMessage,
    );
  }
  return FirebaseException(
    plugin: plugin,
    code: 'unknown',
    message: '$defaultMessage: $e',
  );
}

FirebaseAuthException handleAuthException(dynamic e, String defaultMessage) {
  if (e is FirebaseAuthException) {
    print(e.code);
    return FirebaseAuthException(
      code: e.code,
      message: _translateFirebaseAuthError(e.code) ?? defaultMessage,
    );
  }
  return FirebaseAuthException(
    code: 'unknown',
    message: '$defaultMessage: $e',
  );
}

String? _translateFirebaseError(String code) {
  switch (code) {
    case 'already-joined':
      return 'Bạn đã tham gia nhóm này rồi';
    case 'group-not-found':
      return 'Không tìm thấy nhóm';
    case 'permission-denied':
      return 'Quyền truy cập bị từ chối';
    case 'unavailable':
      return 'Dịch vụ không khả dụng';
    case 'invalid-credential':
      return 'Thông tin đăng nhập không hợp lệ';
    case 'not-found':
      return 'Không tìm thấy';

    case 'network-request-failed':
      return 'Yêu cầu mạng thất bại';
    case 'operation-cancelled':
      return 'Thao tác đã bị hủy';
    case 'data-loss':
      return 'Mất dữ liệu';
    case 'deadline-exceeded':
      return 'Quá thời gian chờ';
    case 'resource-exhausted':
      return 'Tài nguyên đã cạn kiệt';
    case 'failed-precondition':
      return 'Điều kiện tiên quyết không đáp ứng';
    case 'aborted':
      return 'Thao tác bị hủy bỏ';
    case 'out-of-range':
      return 'Giá trị nằm ngoài phạm vi cho phép';
    case 'unimplemented':
      return 'Chức năng chưa được triển khai';
    case 'internal':
      return 'Lỗi nội bộ hệ thống';
    case 'unavailable':
      return 'Dịch vụ không khả dụng';
    case 'data-stale':
      return 'Dữ liệu đã cũ';
    case 'unauthenticated':
      return 'Chưa xác thực';

    default:
      return null;
  }
}

String? _translateFirebaseAuthError(String code) {
  switch (code) {
    case 'user-not-found':
      return 'Không tìm thấy người dùng';
    case 'wrong-password':
      return 'Sai mật khẩu';
    case 'invalid-email':
      return 'Email không hợp lệ';
    case 'user-disabled':
      return 'Tài khoản đã bị vô hiệu hóa';
    case 'email-already-in-use':
      return 'Email đã được sử dụng';
    case 'operation-not-allowed':
      return 'Thao tác không được phép';
    case 'weak-password':
      return 'Mật khẩu yếu';
    case 'account-exists-with-different-credential':
      return 'Tài khoản đã tồn tại với thông tin đăng nhập khác';
    case 'invalid-credential':
      return 'Email hoặc mật khẩu không đúng';
    case 'email-not-verified':
      return 'Tài khoản chưa được xác thực';
    case 'invalid-verification-code':
      return 'Mã xác thực không hợp lệ';
    case 'invalid-verification-id':
      return 'ID xác thực không hợp lệ';
    case 'invalid-phone-number':
      return 'Số điện thoại không hợp lệ';
    case 'credential-already-in-use':
      return 'Thông tin đăng nhập đã được sử dụng';
    case 'user-mismatch':
      return 'Người dùng không khớp';
    case 'requires-recent-login':
      return 'Yêu cầu đăng nhập lại gần đây';
    case 'provider-already-linked':
      return 'Nhà cung cấp đã được liên kết';
    case 'no-such-provider':
      return 'Không tìm thấy nhà cung cấp';
    case 'invalid-user-token':
      return 'Token người dùng không hợp lệ';
    case 'user-token-expired':
      return 'Token người dùng đã hết hạn';
    case 'null-user':
      return 'Không tìm thấy thông tin người dùng';
    case 'app-not-authorized':
      return 'Ứng dụng không được ủy quyền';
    case 'invalid-api-key':
      return 'Khóa API không hợp lệ';
    case 'network-request-failed':
      return 'Yêu cầu mạng thất bại';
    case 'too-many-requests':
      return 'Quá nhiều yêu cầu';

    default:
      return null;
  }
}
