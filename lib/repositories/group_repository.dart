import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/group_model.dart';
import '../models/member_model.dart';
import '../exceptions/firebase_exception.dart';
import 'user_repository.dart';

class GroupRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final UserRepository _userRepository;

  GroupRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    UserRepository? userRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _userRepository = userRepository ?? UserRepository();

  Stream<List<GroupModel>> streamGroups() {
    return _firestore.collection('groups').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => GroupModel.fromFirestore(doc)).toList());
  }

  Stream<GroupModel?> streamGroupById(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((doc) => doc.exists ? GroupModel.fromFirestore(doc) : null);
  }

  Future<void> createGroup(GroupModel group) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('groups').add(group.toMap());
      await docRef.update({'id': docRef.id});
      await _userRepository.saveLastAccessedGroupId(
          group.ownerUserId, docRef.id);
    } on FirebaseException catch (e) {
      throw handleException(e, 'Lỗi tạo nhóm', 'group');
    } catch (e) {
      throw Exception('Lỗi tạo nhóm: $e');
    }
  }

  Future<void> updateGroup(GroupModel group) async {
    try {
      await _firestore.collection('groups').doc(group.id).update(group.toMap());
    } on FirebaseException catch (e) {
      throw handleException(e, 'Lỗi cập nhật nhóm', 'group');
    } catch (e) {
      throw Exception('Lỗi cập nhật nhóm: $e');
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await _firestore.collection('groups').doc(groupId).delete();
    } on FirebaseException catch (e) {
      throw handleException(e, 'Lỗi xóa nhóm', 'group');
    } catch (e) {
      throw Exception('Lỗi xóa nhóm: $e');
    }
  }

  Future<GroupModel?> getGroupById(String groupId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('groups').doc(groupId).get();
      return doc.exists ? GroupModel.fromFirestore(doc) : null;
    } on FirebaseException catch (e) {
      throw handleException(e, 'Lỗi tìm nạp nhóm', 'group');
    } catch (e) {
      throw Exception('Lỗi tìm nạp nhóm: $e');
    }
  }

  Future<GroupModel?> getGroupByCode(String code) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('groups')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return GroupModel.fromFirestore(querySnapshot.docs.first);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw handleException(e, 'Lỗi tìm bằng mã nhóm', 'group');
    } catch (e) {
      throw Exception('Lỗi tìm bằng mã nhóm: $e');
    }
  }

  Future<void> joinGroup(String code, MemberModel member) async {
    try {
      final groupDoc = await _firestore
          .collection('groups')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (groupDoc.docs.isEmpty) {
        throw FirebaseException(
            plugin: 'firestore',
            code: 'not-found',
            message: 'Không tìm thấy nhóm với mã này');
      }

      final groupData = groupDoc.docs.first.data() as Map<String, dynamic>;
      final members = groupData['members'] as List<dynamic>;
      if (members.any((m) => m['id'] == member.id)) {
        print(member.id);
        throw FirebaseException(
            plugin: 'firestore',
            code: 'already-joined',
            message: 'Bạn đã tham gia nhóm này rồi');
      }

      await _firestore.collection('groups').doc(groupDoc.docs.first.id).update({
        'members': FieldValue.arrayUnion([member.toMap()]),
        'memberCount': FieldValue.increment(1),
      });
      await _userRepository.saveLastAccessedGroupId(
          member.id, groupDoc.docs.first.id);
    } on FirebaseException catch (e) {
      throw handleException(e, 'Lỗi tham gia nhóm', 'group');
    } catch (e) {
      throw Exception('Lỗi tham gia nhóm: $e');
    }
  }

  Future<List<GroupModel>> checkUserInGroup(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        return [];
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final lastAccessedGroupId = userData['lastAccessedGroupId'];

      final groupsQuery = await _firestore
          .collection('groups')
          .where('members', arrayContains: {'id': userId}).get();

      List<GroupModel> groups =
          groupsQuery.docs.map((doc) => GroupModel.fromFirestore(doc)).toList();

      if (lastAccessedGroupId != null) {
        groups.sort((a, b) {
          if (a.id == lastAccessedGroupId) return -1;
          if (b.id == lastAccessedGroupId) return 1;
          return 0;
        });
      }

      return groups;
    } on FirebaseException catch (e) {
      throw handleException(e, 'Lỗi kiểm tra nhóm', 'group');
    } catch (e) {
      throw Exception('Lỗi kiểm tra nhóm: $e');
    }
  }
}
