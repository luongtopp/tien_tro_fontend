import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../exceptions/auth_exception.dart';
import '../../models/user.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import '../../utils/error_code_mapper.dart';
import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoginBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(LoginInitial()) {
    on<SubmitLogin>(_onSubmitLogin);
    on<LoginWithGoogle>(_onLoginWithGoogle);
  }

  Future<void> _onSubmitLogin(
      SubmitLogin event, Emitter<LoginState> emit) async {
    emit(LoginValidating());
    try {
      User? user = await _authRepository.loginWithEmailPassword(
          event.email, event.password);
      if (user != null) {
        emit(LoginSuccess("Đăng nhập thành công"));
      }
    } on AuthException catch (e) {
      emit(LoginFailure(mapErrorCodeToMessage(e.code)));
      rethrow;
    } catch (e) {
      emit(LoginError('Đăng nhập thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onLoginWithGoogle(
      LoginWithGoogle event, Emitter<LoginState> emit) async {
    User? user = await _authRepository.loginWithGoogle();
    if (user != null) {
      if (await _userRepository.getUserById(user.uid) == null) {
        final userModel = UserModel(
          id: user.uid,
          fullName: user.displayName!,
          email: user.email!,
          imageUrl: user.photoURL,
          socialId: user.uid,
          bankAccount: null,
        );
        await _userRepository.createUser(userModel);
      }
      emit(LoginSuccess("Đăng nhập thành công"));
    }
  }
}
