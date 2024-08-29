import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<User?> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    }
    return null;
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
              "https://firebasestorage.googleapis.com/v0/b/chia-se-tien-sinh-hoat-t-97a1b.appspot.com/o/avatars%2Fperson_money.png?alt=media&token=3e5be910-1f00-4278-aeba-36aca4af3928";
        }
        await _updateUserProfile(user, fullName, photoURL);
      }
      user = FirebaseAuth.instance.currentUser!;
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Không xác định: $e');
    } catch (e) {
      throw AuthException('system', 'Lỗi khi đăng ký tài khoản: $e');
    }
  }

  Future<void> _updateUserProfile(
      User user, String fullName, String? photoURL) async {
    try {
      await user.updateProfile(
        displayName: fullName,
        photoURL: photoURL ?? "",
      );
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Không xác định: $e');
    } catch (e) {
      throw AuthException('system', 'Không cập nhật được ảnh: $e');
    }
  }

  Future<String?> _uploadImage(File file) async {
    final ref =
        _firebaseStorage.ref().child('avatars/${file.uri.pathSegments.last}');
    try {
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Không xác định: $e');
    } catch (e) {
      throw AuthException('system', 'Lỗi khi đăng ký tài khoản: $e');
    }
  }

  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!userCredential.user!.emailVerified) {
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Tài khoản chưa được xác thực',
        );
      } else {
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Không xác định: $e');
    } catch (e) {
      throw AuthException('system', 'Lỗi khi đăng ký tài khoản: $e');
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Không xác định: $e');
    } catch (e) {
      throw AuthException('system', 'Lỗi khi đăng xuất: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Không xác định: $e');
    } catch (e) {
      throw AuthException(
          'system', 'Lỗi khi lấy thông tin tài khoản hiện tại: $e');
    }
  }
}
