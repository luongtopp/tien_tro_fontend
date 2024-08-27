import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Tạo mới người dùng
  Future<void> createUser(UserModel user) async {
    try {
      // await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Xóa người dùng
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  // Lấy thông tin người dùng
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }
}
