import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/group_model.dart';
import '../../models/member_model.dart';
import '../../repositories/group_repository.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _groupRepository;
  StreamSubscription<List<GroupModel>>? _groupsSubscription;

  GroupBloc({required GroupRepository groupRepository})
      : _groupRepository = groupRepository,
        super(GroupInitial()) {
    on<AddGroup>(_onAddGroup);
    on<UpdateGroup>(_onUpdateGroup);
    on<DeleteGroup>(_onDeleteGroup);
    on<FindGroup>(_onFindGroupById);
    on<FindGroupByCode>(_onFindGroupByCode);
    on<JoinGroup>(_onJoinGroup);
  }
  Future<void> _onAddGroup(AddGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Không tìm thấy người dùng hiện tại');
      }
      String code = await _generateUniqueGroupCode();
      GroupModel newGroup = GroupModel(
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
          )
        ],
        ownerId: currentUser.uid,
        memberCount: 1,
      );
      await _groupRepository.createGroup(newGroup);

      emit(GroupSuccess("Tạo nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(e.message ?? 'Lỗi khi tạo nhóm'));
    } catch (e) {
      emit(GroupError('Tạo nhóm thất bại: ${e.toString()}'));
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

  void _onStreamGroups(StreamGroups event, Emitter<GroupState> emit) {
    _groupsSubscription?.cancel();
    _groupsSubscription = _groupRepository.streamGroups().listen(
      (groups) {
        emit(GroupsLoaded(groups));
      },
      onError: (error) {
        emit(GroupError('Lỗi khi stream các nhóm: $error'));
      },
    );
  }

  Future<String> _generateUniqueGroupCode() async {
    String code;
    do {
      code = _generateRandomCode();
    } while (await _isCodeTaken(code));

    return code;
  }

  String _generateRandomCode() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  Future<bool> _isCodeTaken(String code) async {
    final result = await _groupRepository.getGroupByCode(code);
    return result != null;
  }

  Future<void> _onJoinGroup(JoinGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Không tìm thấy người dùng hiện tại');
      }
      MemberModel member = MemberModel(
        id: currentUser.uid,
        name: currentUser.displayName ?? '',
        avatar: currentUser.photoURL,
        totalExpenseAmount: 0.0,
        balance: 0.0,
        isIdentified: true,
        userAuthId: currentUser.uid,
        role: 'member',
      );

      await _groupRepository.joinGroup(event.code, member);
      emit(GroupSuccess("Tham gia nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(e.message ?? 'Lỗi tham gia nhóm'));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }
}
