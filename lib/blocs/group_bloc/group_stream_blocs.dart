import 'package:chia_se_tien_sinh_hoat_tro/blocs/group_bloc/group_stream_messages.dart';
import 'package:chia_se_tien_sinh_hoat_tro/repositories/group_repository.dart';
import 'package:stream_bloc/stream_bloc.dart';

import 'group_stream_events.dart';
import 'group_stream_states.dart';

class GroupStreamBloc extends StreamBloc<GroupStreamEvent, GroupStreamState> {
  final GroupRepository _groupRepository;

  GroupStreamBloc({
    required GroupRepository groupRepository,
  })  : _groupRepository = groupRepository,
        super(GroupStreamInitial());

  @override
  Stream<GroupStreamState> mapEventToStates(GroupStreamEvent event) async* {
    if (event is StreamGroup) {
      yield GroupStreamValidating();
      try {
        yield* _groupRepository
            .streamUserGroups(event.userId)
            .map(
              (groups) => GroupStreamLoaded(groups),
            )
            .handleError((error) {
          return GroupStreamError(
              '${GroupStreamMessage.streamError.message}: $error');
        });
      } catch (e) {
        yield GroupStreamError('${GroupStreamMessage.setupError.message}: $e');
      }
    } else if (event is ResetGroupStream) {
      yield GroupStreamInitial();
    }
  }
}
