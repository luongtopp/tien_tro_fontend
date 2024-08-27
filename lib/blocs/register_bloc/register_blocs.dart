import 'package:chia_se_tien_sinh_hoat_tro/blocs/register_bloc/register_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../exceptions/auth_exception.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import '../../models/user.dart';
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
      _authRepository.registerWithEmailPassword(
        event.username,
        event.email,
        event.password,
        event.file,
      );

      final user = UserModel(
        id: "_authRepository.uid",
        fullName: event.username,
        email: event.email,
        imageUrl: null,
        socialId: "",
        bankAccount: null,
      );
      await _userRepository.createUser(user);
      emit(RegisterSuccess(
          'Một thư đã được gửi trong email. Nhấp vào liên kết để xác thực.'));
    } on AuthException catch (e) {
      emit(RegisterFailure(_mapErrorCodeToMessage(e.code)));
      rethrow;
    } catch (e) {
      emit(RegisterFailure('Đăng ký thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<RegisterState> emit) async {
    try {
      await _userRepository.updateUser(event.user);
      emit(RegisterSuccess("Sửa tài khoản thất bại"));
    } catch (e) {
      emit(RegisterFailure('Cập nhật tài khoản thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<RegisterState> emit) async {
    try {
      await _userRepository.deleteUser(event.userId);
      emit(RegisterSuccess("Xóa tài khoản thành công"));
    } catch (e) {
      emit(RegisterFailure('Xóa tài khoản thất bại: ${e.toString()}'));
    }
  }

  String _mapErrorCodeToMessage(String errorCode) {
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
        return 'Người dùng này đã bị vô hiệu hóa.';
      default:
        return 'Đã xảy ra lỗi: $errorCode';
    }
  }
}
