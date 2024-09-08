import 'package:equatable/equatable.dart';

import '../../models/group_model.dart';

abstract class GroupStreamState extends Equatable {
  const GroupStreamState();
}

class GroupStreamInitial extends GroupStreamState {
  @override
  List<Object?> get props => [];
}

class GroupStreamValidating extends GroupStreamState {
  @override
  List<Object?> get props => [];
}

class GroupStreamLoaded extends GroupStreamState {
  final List<GroupModel> groupsModel;
  const GroupStreamLoaded(this.groupsModel);

  @override
  List<Object?> get props => [groupsModel];
}

class GroupStreamError extends GroupStreamState {
  final String error;
  const GroupStreamError(this.error);
  @override
  List<Object?> get props => [error];
}
