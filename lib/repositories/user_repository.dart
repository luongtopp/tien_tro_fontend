import 'package:chia_se_tien_sinh_hoat_tro/exceptions/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Tạo mới tài khoản
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Lỗi tạo tài khoản');
    } catch (e) {
      throw AuthException('system', 'Lỗi tạo tài khoản: $e');
    }
  }

  // Cập nhật thông tin tài khoản
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Lỗi sửa tài khoản');
    } catch (e) {
      throw AuthException('system', 'Lỗi tạo tài khoản: $e');
    }
  }

  // Xóa tài khoản
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Lỗi xóa tài khoản');
    } catch (e) {
      throw AuthException('system', 'Lỗi xóa tài khoản: $e');
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
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Lỗi tìm nạp tài khoản');
    } catch (e) {
      throw AuthException('system', 'Lỗi tìm nạp tài khoản: $e');
    }
  }
}
