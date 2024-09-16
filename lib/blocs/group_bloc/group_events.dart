import 'package:equatable/equatable.dart';
import '../../models/expense_model.dart';
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
  final String userId;
  const AddGroup(
      {required this.name, required this.description, required this.userId});
  @override
  List<Object> get props => [name, description, userId];
}

class JoinGroup extends GroupEvent {
  final String code, userId;
  const JoinGroup({required this.code, required this.userId});
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

class RemoveMemberFromGroup extends GroupEvent {
  final String groupId, memberId;
  const RemoveMemberFromGroup(this.groupId, this.memberId);
  @override
  List<Object> get props => [groupId, memberId];
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

class ExpenseAdded extends GroupEvent {
  final ExpenseModel expense;
  const ExpenseAdded(this.expense);
  @override
  List<Object> get props => [expense];
}
