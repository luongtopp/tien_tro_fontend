class FirebaseExceptionCustom implements Exception {
  final String code;
  final String message;

  FirebaseExceptionCustom(this.code, this.message);

  @override
  String toString() => 'AuthException(code: $code, message: $message)';
}
