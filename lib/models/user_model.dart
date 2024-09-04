import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String email;
  final String? bankAccount;
  final String? lastAccessedGroupId;
  UserModel({
    required this.id,
    required this.fullName,
    String? avatarUrl,
    required this.email,
    this.bankAccount,
    this.lastAccessedGroupId,
  }) : avatarUrl = avatarUrl ??
            'https://firebasestorage.googleapis.com/v0/b/chia-se-tien-sinh-hoat-t-97a1b.appspot.com/o/avatars%2Fperson_money.png?alt=media&token=3e5be910-1f00-4278-aeba-36aca4af3928';

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      fullName: data['fullName'],
      avatarUrl: data['imageUrl'],
      email: data['email'],
      bankAccount: data['bankAccount'],
      lastAccessedGroupId: data['lastAccessedGroupId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'imageUrl': avatarUrl,
      'email': email,
      'bankAccount': bankAccount,
      'lastAccessedGroupId': lastAccessedGroupId,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    String? email,
    String? bankAccount,
    String? lastAccessedGroupId,
    bool? hasGroup,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      bankAccount: bankAccount ?? this.bankAccount,
      lastAccessedGroupId: lastAccessedGroupId ?? this.lastAccessedGroupId,
    );
  }

  UserModel copyWithLastAccessedGroupId(String? lastAccessedGroupId) {
    return UserModel(
      id: id,
      fullName: fullName,
      avatarUrl: avatarUrl,
      email: email,
      bankAccount: bankAccount,
      lastAccessedGroupId: lastAccessedGroupId,
    );
  }
}
