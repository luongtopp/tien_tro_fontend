import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../exceptions/firebase_exception.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseStorage? firebaseStorage,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  String? get uid => _firebaseAuth.currentUser?.uid;

  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          throw FirebaseAuthException(
            message: 'Tài khoản chưa được xác thực',
            code: 'email-not-verified',
          );
        }
        return user;
      } else {
        throw Exception('Lỗi khi đăng nhập');
      }
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e, 'Lỗi đăng nhập Google');
    } catch (e) {
      throw Exception(
        'Lỗi đăng nhập Google: $e',
      );
    }
  }

  Future<User?> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          throw FirebaseAuthException(
            message: 'Tài khoản chưa được xác thực',
            code: 'email-not-verified',
          );
        }
        return user;
      } else {
        throw Exception('Lỗi khi đăng nhập');
      }
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e, 'Lỗi đăng nhập không xác định');
    } catch (e) {
      throw Exception(
        'Lỗi khi đăng nhập: $e',
      );
    }
  }

  Future<User?> registerWithEmailPassword(
      {required String email,
      required String password,
      required String fullName,
      File? imageFile}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        final photoURL =
            imageFile != null ? await _uploadImage(imageFile) : null;
        await _updateUserProfile(user, fullName, photoURL);
        return _firebaseAuth.currentUser;
      } else {
        throw Exception('Lỗi khi đăng ký tài khoản');
      }
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e, 'Lỗi đăng ký tài khoản không xác định');
    } catch (e) {
      throw Exception(
        'Lỗi khi đăng ký tài khoản: $e',
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw handleAuthException(e, 'Lỗi gửi email đặt lại mật khẩu');
    }
  }

  Future<void> logout() async {
    try {
      await Future.wait([_googleSignIn.signOut(), _firebaseAuth.signOut()]);
    } catch (e) {
      throw Exception(
        'Lỗi khi đăng xuất: $e',
      );
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      throw Exception(
        'Lỗi khi lấy thông tin tài khoản hiện tại: $e',
      );
    }
  }

  Future<void> _updateUserProfile(
      User user, String fullName, String? photoURL) async {
    try {
      await user.updateProfile(
          displayName: fullName,
          photoURL: photoURL ??
              'https://firebasestorage.googleapis.com/v0/b/chia-se-tien-sinh-hoat-t-97a1b.appspot.com/o/avatars%2Fperson_money.png?alt=media&token=3e5be910-1f00-4278-aeba-36aca4af3928');
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e, 'Lỗi cập nhật hồ sơ không xác định');
    } catch (e) {
      throw Exception(
        'Không cập nhật được hồ sơ: $e',
      );
    }
  }

  Future<String?> _uploadImage(File file) async {
    try {
      final ref = _firebaseStorage
          .ref()
          .child('avatars/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception(
        'Không thể tải lên ảnh: $e',
      );
    }
  }
}
