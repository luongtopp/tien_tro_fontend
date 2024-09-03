import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/group_model.dart';
import '../../models/member_model.dart';
import '../../repositories/group_repository.dart';
import '../../repositories/user_repository.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;
  StreamSubscription<List<GroupModel>>? _groupsSubscription;

  GroupBloc({
    required GroupRepository groupRepository,
    required UserRepository userRepository,
  })  : _groupRepository = groupRepository,
        _userRepository = userRepository,
        super(GroupInitial()) {
    on<AddGroup>(_onAddGroup);
    on<JoinGroup>(_onJoinGroup);
    on<UpdateGroup>(_onUpdateGroup);
    on<DeleteGroup>(_onDeleteGroup);
    on<FindGroup>(_onFindGroupById);
    on<FindGroupByCode>(_onFindGroupByCode);
    on<GetGroupById>(_onGetGroupById);
  }
  @override
  Future<void> close() {
    _groupsSubscription?.cancel();
    return super.close();
  }

  Future<void> _onAddGroup(AddGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Không tìm thấy người dùng hiện tại');
      }

      final code = await _generateUniqueGroupCode();
      final newGroup = GroupModel(
        name: event.name,
        description: event.description,
        code: code,
        isActive: true,
        createdDate: DateTime.now(),
        ownerUserId: currentUser.uid,
        isReceiveNotification: false,
        type: 'group',
        creator: currentUser.uid,
        members: [
          MemberModel(
            id: currentUser.uid,
            name: currentUser.displayName ?? '',
            avatar: currentUser.photoURL,
            totalExpenseAmount: 0.0,
            balance: 0.0,
            isIdentified: true,
            userAuthId: currentUser.uid,
            role: 'owner',
            lastAccessDate: DateTime.now(),
          )
        ],
        ownerId: currentUser.uid,
        memberCount: 1,
      );

      await _groupRepository.createGroup(newGroup);
      emit(CreateGroupSuccess(
        "Tạo nhóm thành công",
        await _groupRepository.checkUserInGroup(currentUser.uid),
        (await _userRepository.getUserById(currentUser.uid))!,
      ));
      emit(GroupByIdLoaded(newGroup));
    } on FirebaseException catch (e) {
      emit(GroupFailure(e.message ?? 'Lỗi khi tạo nhóm'));
    } catch (e) {
      emit(GroupError('Tạo nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onJoinGroup(JoinGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Không tìm thấy người dùng hiện tại');
      }

      final member = MemberModel(
        id: currentUser.uid,
        name: currentUser.displayName ?? '',
        avatar: currentUser.photoURL,
        totalExpenseAmount: 0.0,
        balance: 0.0,
        isIdentified: true,
        userAuthId: currentUser.uid,
        role: 'member',
        lastAccessDate: DateTime.now(),
      );

      await _groupRepository.joinGroup(event.code, member);
      final group = await _groupRepository.getGroupByCode(event.code);
      emit(GroupByIdLoaded(group!));
      emit(
        JoinGroupSuccess(
          "Tham gia nhóm thành công",
          await _groupRepository.checkUserInGroup(currentUser.uid),
          (await _userRepository.getUserById(currentUser.uid))!,
        ),
      );
    } on FirebaseException catch (e) {
      emit(GroupFailure(e.message ?? 'Lỗi tham gia nhóm'));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onUpdateGroup(
      UpdateGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.updateGroup(event.group);
      emit(GroupSuccess("Sửa nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(e.message ?? 'Lỗi khi sửa nhóm'));
      rethrow;
    } catch (e) {
      emit(GroupError('Sửa nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteGroup(
      DeleteGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.deleteGroup(event.groupId);
      emit(GroupSuccess("Xóa nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(e.message ?? 'Lỗi khi xóa nhóm'));
    } catch (e) {
      emit(GroupError('Xóa nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onFindGroupById(
      FindGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.getGroupById(event.groupId);
      emit(GroupSuccess("Tìm nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(e.message ?? 'Lỗi khi tìm nhóm'));
    } catch (e) {
      emit(GroupError('Tìm nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onFindGroupByCode(
      FindGroupByCode event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.getGroupByCode(event.code);
      emit(GroupSuccess("Tìm bằng code nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupError('Tìm bằng code nhóm thất bại: ${e.message}'));
    } catch (e) {
      emit(GroupError('Tìm bằng code nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<String> _generateUniqueGroupCode() async {
    String code;
    do {
      code = List.generate(6, (_) => Random().nextInt(10)).join();
    } while (await _groupRepository.getGroupByCode(code) != null);
    return code;
  }

  Future<void> _onGetGroupById(
      GetGroupById event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      final group = await _groupRepository.getGroupById(event.groupId);

      if (group != null) {
        emit(GroupByIdLoaded(group));
        emit(GroupSuccess("Tìm nhóm thành công"));
      } else {
        emit(GroupFailure('Không tìm thấy nhóm'));
      }
    } on FirebaseException catch (e) {
      emit(GroupFailure(e.message ?? 'Lỗi khi tìm nhóm'));
    }
  }
}
