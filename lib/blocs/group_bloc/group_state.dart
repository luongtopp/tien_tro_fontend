import '../../models/group_model.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupValidating extends GroupState {}

class GroupsLoaded extends GroupState {
  final List<GroupModel> groups;
  GroupsLoaded(this.groups);
}

class GroupActionResult extends GroupState {
  final String message;
  final GroupModel? group;

  GroupActionResult({
    required this.message,
    this.group,
  });
}

class GroupError extends GroupState {
  final String error;
  GroupError(this.error);
}

class UserGroupStatus extends GroupState {
  final GroupModel? group;
  UserGroupStatus({this.group});
}

class GroupStreamLoaded extends GroupState {
  final List<GroupModel> groupsModel;
  GroupStreamLoaded(this.groupsModel);
}
