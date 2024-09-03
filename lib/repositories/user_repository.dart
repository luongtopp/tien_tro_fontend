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
      throw handleException(e, 'Lỗi tạo tài khoản', 'user');
    }
  }

  // Cập nhật thông tin tài khoản
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw handleException(e, 'Lỗi sửa tài khoản', 'user');
    }
  }

  // Xóa tài khoản
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw handleException(e, 'Lỗi xóa tài khoản', 'user');
    }
  }

  // Lấy thông tin tài khoản
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw handleException(e, 'Lỗi tìm nạp tài khoản', 'user');
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
      throw handleException(e, 'Lỗi tìm nạp mã nhóm cuối cùng', 'user');
    }
  }

  Future<void> saveLastAccessedGroupId(String userId, String groupId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'lastAccessedGroupId': groupId});
    } catch (e) {
      throw handleException(e, 'Lỗi lưu mã nhóm cuối cùng', 'user');
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
      throw handleException(e, 'Lỗi kiểm tra nhóm', 'user');
    }
  }
}
