import 'package:equatable/equatable.dart';

abstract class GroupStreamEvent extends Equatable {
  const GroupStreamEvent();
}

class StreamGroup extends GroupStreamEvent {
  final String userId;
  const StreamGroup(this.userId);
  @override
  List<Object> get props => [userId];
}

class ResetGroupStream extends GroupStreamEvent {
  const ResetGroupStream();
  @override
  List<Object> get props => [];
}
