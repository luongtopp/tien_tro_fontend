import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../exceptions/auth_exception.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseStorage? firebaseStorage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  String? get uid => _firebaseAuth.currentUser?.uid;

  Future<String?> _uploadImage(File file) async {
    final ref =
        _firebaseStorage.ref().child('avatars/${file.uri.pathSegments.last}');
    try {
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('Không thể tải lên tệp: $e');
      return null;
    }
  }

  Future<void> _updateUserProfile(
      User user, String fullName, String? photoURL) async {
    try {
      await user.updateProfile(
        displayName: fullName,
        photoURL: photoURL ?? "",
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          e.code, e.message ?? 'Lỗi khi cập nhật thông tin người dùng');
    }
  }

  Future<User?> registerWithEmailPassword(
      String email, String password, String fullName, File? imageFile) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();

        String? photoURL;
        if (imageFile != null) {
          photoURL = await _uploadImage(imageFile);
        } else {
          photoURL =
              "https://firebasestorage.googleapis.com/v0/b/chia-se-tien-sinh-hoat-t-97a1b.appspot.com/o/avatar%2Fperson_money.png?alt=media&token=e0029b6b-a0c3-46e9-bb88-f06b204c4e71";
        }

        await _updateUserProfile(user, fullName, photoURL);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Không xác định');
    } catch (e) {
      throw Exception('Lỗi khi đăng ký người dùng: $e');
    }
  }

  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Lỗi khi đăng nhập: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Lỗi khi đăng xuất: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin người dùng hiện tại: $e');
    }
  }
}
