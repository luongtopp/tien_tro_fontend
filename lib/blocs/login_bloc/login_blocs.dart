import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<SubmitLogin>(_onSubmitLogin);
    on<LoginWithGoogle>(_signInWithGoogle);
  }

  Future<void> _onSubmitLogin(
      SubmitLogin event, Emitter<LoginState> emit) async {
    emit(LoginValidating());
    try {
      await _login(event.email, event.password);
    } catch (e) {
      emit(LoginFailure('Đăng nhập thất bại'));
    } finally {}
  }

  Future<void> _login(String email, String password) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = credential.user;
      if (user != null) {
        if (!user.emailVerified) {
          throw FirebaseAuthException(
              code: 'email-not-verified',
              message: 'Tài khoản chưa được xác thực');
        } else {
          emit(LoginSuccess());
          emit(LoginNotification('Đăng nhập thành công'));

          // Global.storageService
          //     .setString(AppConstants.STORAGE_USER_PROFILE_KEY, '1234');
        }
        return;
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'invalid-credential':
          emit(LoginFailure(
              'Thông tin xác thực không hợp lệ. Vui lòng kiểm tra lại thông tin và thử lại'));
          break;
        case 'email-not-verifie':
          emit(LoginFailure('Tài khoản chưa được xác thực'));
          break;
        case 'invalid-email':
          emit(LoginFailure('Email không hợp lệ'));
          break;
        case 'user-disabled':
          emit(LoginFailure('Tài khoản này đã bị vô hiệu hóa'));
          break;
        case 'user-not-found':
          emit(LoginFailure('Tài khoản không tồn tại'));
          break;
        case 'wrong-password':
          emit(LoginFailure('Mật khẩu không đúng'));
          break;
        case 'too-many-requests':
          emit(LoginFailure('Quá nhiều yêu cầu. Vui lòng thử lại sau.'));
          break;
        default:
          emit(LoginFailure('Đã xảy ra lỗi. Vui lòng thử lại.'));
      }
    } finally {}
  }

  Future<void> _signInWithGoogle(
      LoginWithGoogle event, Emitter<LoginState> emit) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      var user = userCredential.user;
      if (user != null) {
        emit(LoginSuccess());
        emit(LoginNotification('Đăng nhập thành công'));
      }
    }
  }
}
