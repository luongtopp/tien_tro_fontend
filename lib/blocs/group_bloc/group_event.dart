import 'package:equatable/equatable.dart';
import '../../models/group_model.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();
  @override
  List<Object> get props => [];
}

class FetchGroups extends GroupEvent {}

class AddGroupRequested extends GroupEvent {
  final String name;
  final String description;
  final String userId;
  const AddGroupRequested(
      {required this.name, required this.description, required this.userId});
  @override
  List<Object> get props => [name, description, userId];
}

class JoinGroupRequested extends GroupEvent {
  final String code, userId;
  const JoinGroupRequested({required this.code, required this.userId});
  @override
  List<Object> get props => [code, userId];
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

class FindGroupById extends GroupEvent {
  final String groupId;
  const FindGroupById(this.groupId);
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
  final String userId;
  const StreamGroup(this.userId);
  @override
  List<Object> get props => [userId];
}
