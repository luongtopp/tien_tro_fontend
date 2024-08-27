import 'package:chia_se_tien_sinh_hoat_tro/blocs/register_bloc/register_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_events.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(LoginInitial()) {
    on<SubmitRegister>(_onSubmitRegister);
  }

  Future<void> _onSubmitRegister(
      SubmitRegister event, Emitter<RegisterState> emit) async {
    emit(RegisterValidating());
    try {
      await _register(event.username, event.email, event.password);
    } catch (e) {
      emit(RegisterFailure('Đăng nhập thất bại'));
    } finally {}
  }

  Future<void> _register(String username, String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await credential.user?.sendEmailVerification();
        await credential.user?.updateDisplayName(username);
        emit(RegisterNotification(
            'Một thư đã được gửi trong email. Nhấp vào liên kết để xác thực'));
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emit(RegisterFailure('Email đã tồn tại'));
          break;
        default:
          emit(RegisterFailure('Đã xảy ra lỗi. Vui lòng thử lại.'));
      }
    } finally {}
  }
}
