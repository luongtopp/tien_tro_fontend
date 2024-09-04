import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/group_model.dart';
import '../models/member_model.dart';
import '../exceptions/firebase_exception.dart';
import 'auth_repository.dart';
import 'user_repository.dart';

class GroupRepository {
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  GroupRepository({
    FirebaseFirestore? firestore,
    UserRepository? userRepository,
    AuthRepository? authRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _userRepository = userRepository ?? UserRepository(),
        _authRepository = authRepository ?? AuthRepository();

  Future<void> createGroup(GroupModel group) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('groups').add(group.toMap());
      await docRef.update({'id': docRef.id});
      await _userRepository.updateLastAccessedGroupId(
        userId: group.ownerId,
        groupId: docRef.id,
      );
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tạo nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tạo nhóm: $e');
    }
  }

  Future<GroupModel> joinGroup(String code, MemberModel member) async {
    try {
      final groupDoc = await _firestore
          .collection('groups')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (groupDoc.docs.isEmpty) {
        throw FirebaseException(
            code: 'not-found',
            message: 'Không tìm thấy nhóm với mã này',
            plugin: 'group');
      }
      final groupData = GroupModel.fromFirestore(groupDoc.docs.first);
      final members = groupData.members;
      if (members.any((m) => m.id == member.id)) {
        throw FirebaseException(
            code: 'already-joined',
            message: 'Bạn đã tham gia nhóm này rồi',
            plugin: 'group');
      }
      await _firestore.collection('groups').doc(groupDoc.docs.first.id).update({
        'members': FieldValue.arrayUnion([member.toMap()]),
        'memberCount': FieldValue.increment(1),
      });
      await _userRepository.updateLastAccessedGroupId(
        userId: member.id,
        groupId: groupDoc.docs.first.id,
      );
      final updatedGroupDoc = await _firestore
          .collection('groups')
          .doc(groupDoc.docs.first.id)
          .get();

      final updatedGroupData = GroupModel.fromFirestore(updatedGroupDoc);
      return updatedGroupData;
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tham gia nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tham gia nhóm: $e');
    }
  }

  Future<GroupModel> updateGroup(GroupModel group) async {
    try {
      await _firestore.collection('groups').doc(group.id).update(group.toMap());
      final updatedGroupDoc =
          await _firestore.collection('groups').doc(group.id).get();
      return GroupModel.fromFirestore(updatedGroupDoc);
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi cập nhật nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi cập nhật nhóm: $e');
    }
  }

  Future<GroupModel> deleteGroup(String groupId) async {
    try {
      await _firestore.collection('groups').doc(groupId).delete();

      // Lấy danh sách nhóm của người dùng
      List<GroupModel> userGroups = await getUserGroups(_authRepository.uid!);

      // Nếu có nhóm, trả về nhóm truy cập gần nhất
      if (userGroups.isNotEmpty) {
        return userGroups.first;
      } else {
        throw Exception('Không còn nhóm nào sau khi xóa');
      }
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi xóa nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi xóa nhóm: $e');
    }
  }

  Future<GroupModel> getGroupById(String groupId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('groups').doc(groupId).get();
      if (!doc.exists) {
        throw FirebaseException(
            plugin: 'firestore',
            code: 'not-found',
            message: 'Không tìm thấy nhóm với ID này');
      }
      return GroupModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tìm nạp nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tìm nạp nhóm: $e');
    }
  }

  Future<List<GroupModel>> getAllGroups() async {
    try {
      final groupsQuery = await _firestore.collection('groups').get();
      return groupsQuery.docs
          .map((doc) => GroupModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tìm nạp tất cả nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tìm nạp tất cả nhóm: $e');
    }
  }

  Future<GroupModel> getGroupByCode(String code) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('groups')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return GroupModel.fromFirestore(querySnapshot.docs.first);
      } else {
        throw FirebaseException(
            plugin: 'firestore',
            code: 'not-found',
            message: 'Không tìm thấy nhóm với mã này');
      }
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tìm bằng mã nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi tìm bằng mã nhóm: $e');
    }
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      List<GroupModel> resultGroups = [];

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('groups').get();
      for (var doc in querySnapshot.docs) {
        GroupModel groupData = GroupModel.fromFirestore(doc);
        List<MemberModel> members = groupData.members;
        for (var member in members) {
          if (member.id == userId) {
            resultGroups.add(groupData);
            break;
          }
        }
      }

      final userDoc = await _userRepository.getUserById(userId);
      final userData = userDoc?.toMap();
      if (userData == null) {
        return [];
      }

      resultGroups.sort((a, b) {
        DateTime? getLastAccessDate(GroupModel group) {
          return group.members
              .map((member) => member.lastAccessDate)
              .where((date) => date != null)
              .reduce((a, b) => a!.isAfter(b!) ? a : b);
        }

        final aLastAccess = getLastAccessDate(a);
        final bLastAccess = getLastAccessDate(b);

        if (aLastAccess == null && bLastAccess == null) return 0;
        if (aLastAccess == null) return 1;
        if (bLastAccess == null) return -1;

        return bLastAccess.compareTo(aLastAccess);
      });
      return resultGroups;
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi kiểm tra nhóm', plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi kiểm tra nhóm: $e');
    }
  }

  Future<double> getTotalGroupExpense(String groupId) async {
    try {
      final groupDoc = await _firestore.collection('groups').doc(groupId).get();
      if (!groupDoc.exists) {
        throw FirebaseException(
            plugin: 'firestore',
            code: 'not-found',
            message: 'Không tìm thấy nhóm với ID này');
      }
      final groupData = GroupModel.fromFirestore(groupDoc);
      double totalExpense = 0.0;
      for (var member in groupData.members) {
        totalExpense += member.totalExpenseAmount;
      }
      return totalExpense;
    } on FirebaseException catch (e) {
      throw handleException(
          e: e,
          defaultMessage: 'Lỗi lấy tổng chi phí của nhóm',
          plugin: 'group');
    } catch (e) {
      throw Exception('Lỗi lấy tổng chi phí của nhóm: $e');
    }
  }
}
