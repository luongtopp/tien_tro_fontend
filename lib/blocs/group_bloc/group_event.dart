import 'package:equatable/equatable.dart';

import '../../models/group_model.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class FetchGroups extends GroupEvent {}

class AddGroup extends GroupEvent {
  final String name;
  final String description;

  const AddGroup({
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [name, description];
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

class StreamGroup extends GroupEvent {
  const StreamGroup(this.userId);
  final String userId;
  @override
  List<Object> get props => [userId];
}

class GetGroupById extends GroupEvent {
  final String groupId;

  const GetGroupById({required this.groupId});
  @override
  List<Object> get props => [groupId];
}

class JoinGroup extends GroupEvent {
  final String code;

  const JoinGroup(this.code);

  @override
  List<Object> get props => [code];
}

class FetchGroupExpense extends GroupEvent {
  final String groupId;

  const FetchGroupExpense(this.groupId);

  @override
  List<Object> get props => [groupId];
}
