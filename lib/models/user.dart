import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullName;
  final String? imageUrl;
  final String email;
  final String socialId;
  final String? bankAccount;

  UserModel({
    required this.id,
    required this.fullName,
    required this.imageUrl,
    required this.email,
    required this.socialId,
    this.bankAccount,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      fullName: data['fullName'],
      imageUrl: data['imageUrl'],
      email: data['email'],
      socialId: data['socialId'],
      bankAccount: data['bankAccount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'imageUrl': imageUrl,
      'email': email,
      'socialId': socialId,
      'bankAccount': bankAccount,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? imageUrl,
    String? email,
    String? socialId,
    String? bankAccount,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      socialId: socialId ?? this.socialId,
      bankAccount: bankAccount ?? this.bankAccount,
    );
  }
}
