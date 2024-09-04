import 'package:cloud_firestore/cloud_firestore.dart';
import '../exceptions/firebase_exception.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Tạo mới tài khoản
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tạo tài khoản', plugin: 'user');
    }
  }

  // Cập nhật thông tin tài khoản
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi sửa tài khoản', plugin: 'user');
    }
  }

  // Xóa tài khoản
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi xóa tài khoản', plugin: 'user');
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi tìm nạp tài khoản', plugin: 'user');
    } catch (e) {
      throw Exception('Lỗi tìm nạp tài khoản: $e');
    }
  }

  Future<String?> getLastAccessedGroupId(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc['lastAccessedGroupId'];
      }
      return null;
    } catch (e) {
      throw handleException(
          e: e,
          defaultMessage: 'Lỗi tìm nạp mã nhóm cuối cùng',
          plugin: 'user');
    }
  }

  Future<void> updateLastAccessedGroupId(
      {required String userId, required String groupId}) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'lastAccessedGroupId': groupId});
    } catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi lưu mã nhóm cuối cùng', plugin: 'user');
    }
  }

  Future<bool> checkUserHasGroup(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc['hasGroup'];
      }
      return false;
    } catch (e) {
      throw handleException(
          e: e, defaultMessage: 'Lỗi kiểm tra nhóm', plugin: 'user');
    }
  }
}
