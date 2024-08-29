import 'package:chia_se_tien_sinh_hoat_tro/exceptions/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/group.dart';

class GroupRepository {
  final FirebaseFirestore _firestore;

  GroupRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Stream các nhóm từ Firestore
  Stream<List<GroupModel>> streamGroups() {
    return _firestore.collection('groups').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GroupModel.fromFirestore(doc);
      }).toList();
    });
  }

  // Stream một nhóm cụ thể theo groupId
  Stream<GroupModel?> streamGroupById(String groupId) {
    return _firestore.collection('groups').doc(groupId).snapshots().map((doc) {
      if (doc.exists) {
        return GroupModel.fromFirestore(doc);
      }
      return null;
    });
  }

  // Tạo mới nhóm
  Future<void> createGroup(GroupModel group) async {
    try {
      await _firestore.collection('groups').doc(group.id).set(group.toMap());
    } on FirebaseException catch (e) {
      throw AuthException(e.code, e.message ?? 'Lỗi tạo nhóm');
    } catch (e) {
      throw AuthException('system', 'Lỗi tạo nhóm: $e');
    }
  }

  // Cập nhật thông tin nhóm
  Future<void> updateGroup(GroupModel group) async {
    try {
      await _firestore.collection('groups').doc(group.id).update(group.toMap());
    } on FirebaseException catch (e) {
      throw AuthException(e.code, e.message ?? 'Lỗi cập nhật nhóm');
    } catch (e) {
      throw AuthException('system', 'Lỗi cập nhật nhóm: $e');
    }
  }

  // Xóa nhóm
  Future<void> deleteGroup(String groupId) async {
    try {
      await _firestore.collection('groups').doc(groupId).delete();
    } on FirebaseException catch (e) {
      throw AuthException(e.code, e.message ?? 'Lỗi xóa nhóm');
    } catch (e) {
      throw AuthException('system', 'Lỗi xóa nhóm: $e');
    }
  }

  // Lấy thông tin nhóm
  Future<GroupModel?> getGroupById(String groupId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('groups').doc(groupId).get();
      if (doc.exists) {
        return GroupModel.fromFirestore(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      throw AuthException(e.code, e.message ?? 'Lỗi tìm nạp nhóm');
    } catch (e) {
      throw AuthException('system', 'Lỗi tìm nạp nhóm: $e');
    }
  }

  // Lấy thông tin nhóm bằng code
  Future<GroupModel?> getGroupByCode(String code) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('groups')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return GroupModel.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } on FirebaseException catch (e) {
      throw AuthException(e.code, e.message ?? 'Lỗi tìm bằng mã nhóm');
    } catch (e) {
      throw AuthException('system', 'Lỗi tìm bằng mã nhóm: $e');
    }
  }

  Future<bool> checkUserInGroup() async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    final userId = user.uid;
    final groupsCollection = _firestore.collection('groups');

    try {
      final querySnapshot = await groupsCollection
          .where('members', arrayContains: {'userId': userId}).get();
      return querySnapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw FirebaseException(
          plugin: e.plugin, message: e.message, code: e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
