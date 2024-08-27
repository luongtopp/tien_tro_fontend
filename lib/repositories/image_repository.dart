// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

// class ImageRepository {
//   final FirebaseStorage _firebaseStorage;

//   ImageRepository({
//     FirebaseStorage? firebaseStorage,
//   }) : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

//   Future<String?> uploadFile(ImagePicker picker) async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       File file = File(pickedFile.path);
//       Reference ref =
//           _firebaseStorage.ref().child('avatars/${file.uri.pathSegments.last}');

//       try {
//         await ref.putFile(file);

//         String downloadURL = await ref.getDownloadURL();
//         return downloadURL;
//       } on FirebaseException catch (e) {
//         print('Failed to upload file: $e');
//       }
//     }
//     return null;
//   }
// }
