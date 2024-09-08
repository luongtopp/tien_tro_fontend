import 'package:equatable/equatable.dart';

import '../../models/group_model.dart';
import '../../models/user_model.dart';

abstract class GroupState extends Equatable {
  const GroupState();
}

class GroupInitial extends GroupState {
  @override
  List<Object?> get props => [];
}

class GroupValidating extends GroupState {
  @override
  List<Object?> get props => [];
}

class GroupsLoaded extends GroupState {
  final List<GroupModel> groups;
  const GroupsLoaded(this.groups);
  @override
  List<Object?> get props => [groups];
}

class GroupActionResult extends GroupState {
  final String message;
  final GroupModel? group;

  const GroupActionResult({
    required this.message,
    this.group,
  });
  @override
  List<Object?> get props => [message, group];
}

class GroupActionCompleted extends GroupState {
  final UserModel user;
  final List<GroupModel> userGroups;
  final GroupModel group;
  const GroupActionCompleted({
    required this.user,
    required this.userGroups,
    required this.group,
  });
  @override
  List<Object?> get props => [user, userGroups, group];
}

class GroupError extends GroupState {
  final String error;
  const GroupError(this.error);
  @override
  List<Object?> get props => [error];
}

class UserGroupStatus extends GroupState {
  final GroupModel? group;
  const UserGroupStatus({this.group});
  @override
  List<Object?> get props => [group];
}
