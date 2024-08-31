import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/group_repository.dart';
import '../../repositories/user_repository.dart';
import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;

  LoginBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required GroupRepository groupRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _groupRepository = groupRepository,
        super(LoginInitial()) {
    on<SubmitLogin>(_onSubmitLogin);
    on<LoginWithGoogle>(_onLoginWithGoogle);
    on<Logout>(_onLogout);
  }

  Future<void> _onSubmitLogin(
      SubmitLogin event, Emitter<LoginState> emit) async {
    emit(LoginValidating());
    try {
      User? user = await _authRepository.loginWithEmailPassword(
          event.email, event.password);
      if (user != null) {
        UserModel userModel = (await _userRepository.getUserById(user.uid))!;
        List<GroupModel>? groups =
            await _groupRepository.checkUserInGroup(user.uid);
        emit(LoginSuccess(
          "Đăng nhập thành công",
          groups,
          userModel,
        ));
      } else {
        emit(LoginFailure("Đăng nhập thất bại: Không thể xác thực người dùng"));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? 'Đăng nhập thất bại'));
    } catch (e) {
      emit(LoginError('Đăng nhập thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onLoginWithGoogle(
      LoginWithGoogle event, Emitter<LoginState> emit) async {
    emit(LoginValidating());
    try {
      User? user = await _authRepository.loginWithGoogle();
      if (user != null) {
        UserModel userModel;
        if (await _userRepository.getUserById(user.uid) == null) {
          userModel = UserModel(
            id: user.uid,
            fullName: user.displayName ?? 'Unknown',
            email: user.email ?? 'No email',
            imageUrl: user.photoURL,
            socialId: user.uid,
            bankAccount: null,
            lastAccessedGroupId: null,
          );
          await _userRepository.createUser(userModel);
        } else {
          userModel = (await _userRepository.getUserById(user.uid))!;
        }
        List<GroupModel>? groups =
            await _groupRepository.checkUserInGroup(user.uid);
        emit(LoginSuccess("Đăng nhập thành công", groups, userModel));
      } else {
        emit(LoginFailure("Đăng nhập thất bại: Không thể xác thực với Google"));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? 'Đăng nhập thất bại'));
    } catch (e) {
      emit(LoginError('Đăng nhập thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<LoginState> emit) async {
    emit(LoginValidating());
    try {
      await _authRepository.logout();
      emit(LoginOutSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? 'Đăng xuất thất bại'));
    } catch (e) {
      emit(LoginError('Đăng xuất thất bại: ${e.toString()}'));
    }
  }
}
