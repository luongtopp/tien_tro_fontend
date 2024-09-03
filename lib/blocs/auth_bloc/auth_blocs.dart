import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LoginWithGoogleRequested>(_onLoginWithGoogleRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.loginWithEmailPassword(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        final userModel = await _userRepository.getUserById(user.uid);
        if (userModel != null) {
          emit(AuthAuthenticated(userModel, userModel.hasGroup));
        }
      } else {
        throw FirebaseAuthException(
          code: 'login-failed',
          message: 'Đăng nhập thất bại',
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message!));
    } catch (e) {
      emit(AuthError('Đăng nhập thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onLoginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.loginWithGoogle();
      if (user != null) {
        UserModel? userModel = await _userRepository.getUserById(user.uid);
        if (userModel == null) {
          userModel = UserModel(
            id: user.uid,
            fullName: user.displayName ?? '',
            avatarUrl: user.photoURL,
            email: user.email ?? '',
            socialId: user.uid,
            hasGroup: false,
          );
          await _userRepository.createUser(userModel);
        }
        emit(AuthAuthenticated(userModel, userModel.hasGroup));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message!));
    } catch (e) {
      emit(AuthError('Đăng nhập bằng Google thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.sendPasswordResetEmail(event.email);
      emit(const AuthSuccess(
          'Một thư đã được gửi trong email. Nhấp vào liên kết để xác thực.'));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message!));
    } catch (e) {
      emit(AuthError('Gửi email đặt lại mật khẩu thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.registerWithEmailPassword(
        email: event.email,
        password: event.password,
        fullName: event.name,
        imageFile: event.imageFile,
      );
      if (user != null) {
        final userModel = UserModel(
          id: user.uid,
          fullName: event.name,
          avatarUrl: user.photoURL,
          email: user.email!,
          socialId: user.uid,
          bankAccount: null,
          lastAccessedGroupId: null,
          hasGroup: false,
        );
        await _userRepository.createUser(userModel);
        emit(AuthAuthenticated(userModel, false));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message!));
    } catch (e) {
      emit(AuthError('Đăng ký thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message!));
    } catch (e) {
      emit(AuthError('Đăng xuất thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser != null) {
        final userModel = await _userRepository.getUserById(currentUser.uid);
        if (userModel != null) {
          emit(AuthAuthenticated(userModel, userModel.hasGroup));
        } else {
          throw FirebaseException(
            plugin: 'auth',
            code: 'user-not-found',
            message: 'Không tìm thấy người dùng',
          );
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message!));
    } catch (e) {
      emit(AuthError('Kiểm tra xác thực thất bại: ${e.toString()}'));
    }
  }
}
