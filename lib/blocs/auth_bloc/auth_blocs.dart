import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/group_repository.dart';
import '../../repositories/user_repository.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required GroupRepository groupRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _groupRepository = groupRepository,
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
          final groups = await _groupRepository.getUserGroups(userModel.id);
          emit(AuthAuthenticated(userModel, groups));
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
      emit(AuthError(e.toString()));
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
          );
          await _userRepository.createUser(userModel);
        }
        final groups = await _groupRepository.getUserGroups(userModel.id);
        emit(AuthAuthenticated(userModel, groups));
      }
      emit(AuthCanceled());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message!));
    } catch (e) {
      emit(AuthError(e.toString()));
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
      emit(AuthError(e.toString()));
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
        );
        await _userRepository.createUser(userModel);

        emit(const AuthSuccess(
            'Một email đã được gửi đến email của bạn. Nhấp vào liên kết để xác thực.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message!));
    } catch (e) {
      emit(AuthError(e.toString()));
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
      emit(AuthError(e.toString()));
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
          final groups = await _groupRepository.getUserGroups(userModel.id);
          emit(AuthAuthenticated(userModel, groups));
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
      emit(AuthError(e.toString()));
    }
  }
}
