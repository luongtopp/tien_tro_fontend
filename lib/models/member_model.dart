import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String id;
  final String name;
  final String? avatar;
  final String? description;
  final double totalExpenseAmount;
  final double balance;
  final bool isIdentified;
  final String? userAuthId;
  final String role;
  final String? bankAccountInfo;

  MemberModel({
    required this.id,
    required this.name,
    this.avatar,
    this.description,
    required this.totalExpenseAmount,
    required this.balance,
    required this.isIdentified,
    this.userAuthId,
    required this.role,
    this.bankAccountInfo,
  });

  factory MemberModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return MemberModel(
      id: doc.id,
      name: data?['name'] ?? '',
      avatar: data?['avatar'],
      description: data?['description'],
      totalExpenseAmount:
          (data?['totalExpenseAmount'] as num?)?.toDouble() ?? 0.0,
      balance: (data?['balance'] as num?)?.toDouble() ?? 0.0,
      isIdentified: data?['isIdentified'] ?? false,
      userAuthId: data?['userAuthId'],
      role: data?['role'] ?? '',
      bankAccountInfo: data?['bankAccountInfo'],
    );
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'],
      description: map['description'],
      totalExpenseAmount:
          (map['totalExpenseAmount'] as num?)?.toDouble() ?? 0.0,
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      isIdentified: map['isIdentified'] ?? false,
      userAuthId: map['userAuthId'],
      role: map['role'] ?? '',
      bankAccountInfo: map['bankAccountInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'description': description,
      'totalExpenseAmount': totalExpenseAmount,
      'balance': balance,
      'isIdentified': isIdentified,
      'userAuthId': userAuthId,
      'role': role,
      'bankAccountInfo': bankAccountInfo,
    };
  }

  MemberModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? description,
    double? totalExpenseAmount,
    double? balance,
    bool? isIdentified,
    String? userAuthId,
    String? role,
    String? bankAccountInfo,
  }) {
    return MemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      totalExpenseAmount: totalExpenseAmount ?? this.totalExpenseAmount,
      balance: balance ?? this.balance,
      isIdentified: isIdentified ?? this.isIdentified,
      userAuthId: userAuthId ?? this.userAuthId,
      role: role ?? this.role,
      bankAccountInfo: bankAccountInfo ?? this.bankAccountInfo,
    );
  }
}
