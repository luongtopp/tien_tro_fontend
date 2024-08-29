import 'package:equatable/equatable.dart';

import '../../models/group.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class FetchGroups extends GroupEvent {}

class AddGroup extends GroupEvent {
  final GroupModel group;

  const AddGroup(this.group);

  @override
  List<Object> get props => [group];
}

class UpdateGroup extends GroupEvent {
  final GroupModel group;

  const UpdateGroup(this.group);

  @override
  List<Object> get props => [group];
}

class DeleteGroup extends GroupEvent {
  final String groupId;

  const DeleteGroup(this.groupId);

  @override
  List<Object> get props => [groupId];
}

class FindGroup extends GroupEvent {
  final String groupId;

  const FindGroup(this.groupId);
  @override
  List<Object> get props => [groupId];
}

class FindGroupByCode extends GroupEvent {
  final String code;

  const FindGroupByCode(this.code);
  @override
  List<Object> get props => [code];
}

class CheckUserGroup extends GroupEvent {
  final String userId;

  const CheckUserGroup(this.userId);
  @override
  List<Object> get props => [userId];
}

class StreamGroups extends GroupEvent {
  const StreamGroups();
  @override
  List<Object> get props => [];
}
