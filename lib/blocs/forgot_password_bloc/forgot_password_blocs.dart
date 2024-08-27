import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_password_events.dart';
import 'forgot_password_states.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<SubmitForgotPassword>(_onSubmitForgotPassword);
  }

  Future<void> _onSubmitForgotPassword(
      SubmitForgotPassword event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordValidating());
    try {
      await _forgotPassword(event.email);
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> _forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      emit(ForgotPasswordNotification(
          'Một thư đã được gửi trong email. Nhấp vào liên kết để để đổi mật khẩu'));
      emit(ForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      print(e.code);
      emit(ForgotPasswordError(e.toString()));
    }
  }
}
