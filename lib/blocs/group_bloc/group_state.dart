import 'package:chia_se_tien_sinh_hoat_tro/models/group.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupValidating extends GroupState {}

class GroupsLoaded extends GroupState {
  final List<GroupModel> groups;
  GroupsLoaded(this.groups);
}

class GroupSuccess extends GroupState {
  final String message;
  GroupSuccess(this.message);
}

class GroupFailure extends GroupState {
  final String error;
  GroupFailure(this.error);
}

class GroupError extends GroupState {
  final String error;
  GroupError(this.error);
}

class GroupNotification extends GroupState {
  final String notificationMessage;
  GroupNotification(this.notificationMessage);
}

class UserHasGroups extends GroupState {
  UserHasGroups();
}

class UserHasNoGroups extends GroupState {
  UserHasNoGroups();
}
