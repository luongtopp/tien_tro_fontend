import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/group_model.dart';
import '../../models/member_model.dart';
import '../../repositories/group_repository.dart';
import '../../repositories/user_repository.dart';
import 'group_events.dart';
import 'group_states.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;

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
    on<FindGroupById>(_onFindGroupById);
    on<FindGroupByCode>(_onFindGroupByCode);
  }

  Future<void> _onAddGroup(AddGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      final user = await _userRepository.getUserById(event.userId);
      final code = await _groupRepository.generateUniqueGroupCode();
      final newGroup = GroupModel(
        name: event.name,
        description: event.description,
        code: code,
        isActive: true,
        createdDate: DateTime.now(),
        isReceiveNotification: false,
        type: 'group',
        creator: user!.fullName,
        members: [
          MemberModel(
            id: user.id,
            name: user.fullName,
            avatarUrl: user.avatarUrl,
            totalExpenseAmount: 0.0,
            balance: 0.0,
            isIdentified: true,
            role: 'owner',
            lastAccessDate: DateTime.now(),
          )
        ],
        ownerId: user.id,
        memberCount: 1,
      );

      await _groupRepository.createGroup(newGroup);
      final userGroups = await _groupRepository.getUserGroups(user.id);
      // Lấy user mới sau khi tạo nhóm
      final updatedUser = await _userRepository.getUserById(user.id);
      if (updatedUser == null) {
        throw Exception('Không thể lấy thông tin người dùng sau khi tạo nhóm');
      }
      emit(GroupActionCompleted(
        user: updatedUser,
        userGroups: userGroups,
        group: newGroup,
      ));
    } on FirebaseException catch (e) {
      emit(GroupError(e.message!));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onJoinGroup(JoinGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      final user = await _userRepository.getUserById(event.userId);
      final member = MemberModel(
        id: user!.id,
        name: user.fullName,
        avatarUrl: user.avatarUrl,
        totalExpenseAmount: 0.0,
        balance: 0.0,
        isIdentified: true,
        role: 'member',
        lastAccessDate: DateTime.now(),
      );

      final group = await _groupRepository.joinGroup(event.code, member);
      final userGroups = await _groupRepository.getUserGroups(user.id);
      final updatedUser = await _userRepository.getUserById(user.id);
      if (updatedUser == null) {
        throw Exception(
            'Không thể lấy thông tin người dùng sau khi tham gia nhóm');
      }
      emit(GroupActionCompleted(
          user: updatedUser, userGroups: userGroups, group: group));
    } on FirebaseException catch (e) {
      emit(GroupError(e.message!));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onUpdateGroup(
      UpdateGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.updateGroup(event.group);
      final group = await _groupRepository.getGroupById(event.group.id!);
      emit(GroupActionResult(message: 'Sửa nhóm thành công', group: group));
    } on FirebaseException catch (e) {
      emit(GroupError(e.message!));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onDeleteGroup(
      DeleteGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.deleteGroup(event.groupId);
      emit(GroupActionResult(message: "Xóa nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupError(e.message ?? 'Lỗi khi xóa nhóm'));
    } catch (e) {
      emit(GroupError('Xóa nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onFindGroupById(
      FindGroupById event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      final group = await _groupRepository.getGroupById(event.groupId);
      emit(GroupActionResult(message: "Tìm nhóm thành công", group: group));
    } on FirebaseException catch (e) {
      emit(GroupError(e.message ?? 'Lỗi khi tìm nhóm'));
    } catch (e) {
      emit(GroupError('Tìm nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onFindGroupByCode(
      FindGroupByCode event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      final group = await _groupRepository.getGroupByCode(event.code);
      emit(GroupActionResult(
          message: "Tìm bằng code nhóm thành công", group: group));
    } on FirebaseException catch (e) {
      emit(GroupError('Tìm bằng code nhóm thất bại: ${e.message}'));
    } catch (e) {
      emit(GroupError('Tìm bằng code nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveMember(
      RemoveMemberFromGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.removeMemberFromGroup(
          event.groupId, event.memberId);
      final updatedGroup = await _groupRepository.getGroupById(event.groupId);
      emit(GroupActionResult(
          message: "Xóa thành viên khỏi nhóm thành công", group: updatedGroup));
    } on FirebaseException catch (e) {
      emit(GroupError(e.message ?? 'Lỗi khi xóa thành viên khỏi nhóm'));
    } catch (e) {
      emit(GroupError('Xóa thành viên khỏi nhóm thất bại: ${e.toString()}'));
    }
  }
}
