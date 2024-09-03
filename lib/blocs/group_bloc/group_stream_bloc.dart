import 'package:chia_se_tien_sinh_hoat_tro/blocs/group_bloc/group_event.dart';
import 'package:chia_se_tien_sinh_hoat_tro/blocs/group_bloc/group_state.dart';
import 'package:chia_se_tien_sinh_hoat_tro/blocs/group_bloc/group_stream_messages.dart';
import 'package:chia_se_tien_sinh_hoat_tro/repositories/group_repository.dart';
import 'package:stream_bloc/stream_bloc.dart';

import '../../models/group_model.dart';
import '../../models/member_model.dart';

class GroupStreamBloc extends StreamBloc<StreamGroup, GroupState> {
  final GroupRepository _groupRepository;

  GroupStreamBloc({
    required GroupRepository groupRepository,
  })  : _groupRepository = groupRepository,
        super(GroupInitial());

  @override
  Stream<GroupState> mapEventToStates(GroupEvent event) async* {
    yield GroupValidating();
    try {
      if (event is StreamGroup) {
        List<GroupModel> groups = await _groupRepository.getAllGroups();
        List<GroupModel> resultGroups = [];
        for (var group in groups) {
          List<MemberModel> members = group.members;
          for (var member in members) {
            if (member.id == event.userId) {
              resultGroups.add(group);
              break;
            }
          }
        }
        resultGroups.sort((a, b) {
          DateTime? dateA =
              a.members.firstWhere((m) => m.id == event.userId).lastAccessDate;
          DateTime? dateB =
              b.members.firstWhere((m) => m.id == event.userId).lastAccessDate;
          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;
          return dateB.compareTo(dateA);
        });
        yield GroupStreamLoaded(resultGroups);
      }
    } catch (e) {
      yield GroupError(
          '${GroupStreamMessage.setupError.message}: ${e.toString()}');
    }
  }
}
