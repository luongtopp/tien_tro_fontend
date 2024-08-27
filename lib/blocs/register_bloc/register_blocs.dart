import 'package:chia_se_tien_sinh_hoat_tro/blocs/register_bloc/register_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../exceptions/auth_exception.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import '../../models/user.dart';
import '../../utils/error_code_mapper.dart';
import 'register_events.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  RegisterBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(LoginInitial()) {
    on<SubmitRegister>(_onSubmitRegister);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onSubmitRegister(
      SubmitRegister event, Emitter<RegisterState> emit) async {
    emit(RegisterValidating());
    try {
      User? user = await _authRepository.registerWithEmailPassword(
        event.email,
        event.password,
        event.username,
        event.file,
      );
      if (user != null) {
        final userModel = UserModel(
          id: user.uid,
          fullName: user.displayName!,
          email: event.email,
          imageUrl: user.photoURL,
          socialId: user.uid,
          bankAccount: null,
        );
        await _userRepository.createUser(userModel);
      }
      emit(RegisterSuccess(
          'Một thư đã được gửi trong email. Nhấp vào liên kết để xác thực.'));
    } on AuthException catch (e) {
      emit(RegisterFailure(mapErrorCodeToMessage(e.code)));
      rethrow;
    } catch (e) {
      emit(RegisterError('Đăng ký thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<RegisterState> emit) async {
    try {
      await _userRepository.updateUser(event.user);
      emit(RegisterSuccess("Sửa tài khoản thất bại"));
    } catch (e) {
      emit(RegisterError('Cập nhật tài khoản thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<RegisterState> emit) async {
    try {
      await _userRepository.deleteUser(event.userId);
      emit(RegisterSuccess("Xóa tài khoản thành công"));
    } catch (e) {
      emit(RegisterError('Xóa tài khoản thất bại: ${e.toString()}'));
    }
  }
}
