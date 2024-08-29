import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/group.dart';
import '../../repositories/group_repository.dart';
import '../../utils/error_code_mapper.dart';
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
    on<CheckUserGroup>(_onCheckUserGroup);
    on<FindGroup>(_onFindGroupById);
    on<FindGroupByCode>(_onFindGroupByCode);
  }

  Future<void> _onAddGroup(AddGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.createGroup(event.group);
      emit(GroupSuccess("Tạo nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(mapErrorCodeToMessage(e.code)));
      rethrow;
    } catch (e) {
      emit(GroupFailure('Tạo nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateGroup(
      UpdateGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.updateGroup(event.group);
      emit(GroupSuccess("Sửa nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(mapErrorCodeToMessage(e.code)));
      rethrow;
    } catch (e) {
      emit(GroupFailure('Sửa nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteGroup(
      DeleteGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.deleteGroup(event.groupId);
      emit(GroupSuccess("Xóa nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(mapErrorCodeToMessage(e.code)));
      rethrow;
    } catch (e) {
      emit(GroupFailure('Xóa nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onFindGroupById(
      FindGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.getGroupById(event.groupId);
      emit(GroupSuccess("Tìm nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(mapErrorCodeToMessage(e.code)));
      rethrow;
    } catch (e) {
      emit(GroupFailure('Tìm nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onFindGroupByCode(
      FindGroupByCode event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.getGroupByCode(event.code);
      emit(GroupSuccess("Tìm bằng code nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(mapErrorCodeToMessage(e.code)));
      rethrow;
    } catch (e) {
      emit(GroupFailure('Tìm bằng code nhóm thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onCheckUserGroup(
      CheckUserGroup event, Emitter<GroupState> emit) async {
    emit(GroupValidating());
    try {
      await _groupRepository.getGroupById(event.userId);
      emit(GroupSuccess("Tạo nhóm thành công"));
    } on FirebaseException catch (e) {
      emit(GroupFailure(mapErrorCodeToMessage(e.code)));
      rethrow;
    } catch (e) {
      emit(GroupFailure('Tạo nhóm thất bại: ${e.toString()}'));
    }
  }

  void _onStreamGroups(StreamGroups event, Emitter<GroupState> emit) {
    _groupsSubscription?.cancel();
    _groupsSubscription = _groupRepository.streamGroups().listen(
      (groups) {
        emit(GroupsLoaded(groups));
      },
      onError: (error) {
        emit(GroupFailure('Lỗi khi stream các nhóm: $error'));
      },
    );
  }
}
