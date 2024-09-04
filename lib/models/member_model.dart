import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? description;
  final double totalExpenseAmount;
  final double balance;
  final bool isIdentified;
  final String role;
  final String? bankAccountInfo;
  final DateTime? lastAccessDate;

  MemberModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.description,
    required this.totalExpenseAmount,
    required this.balance,
    required this.isIdentified,
    required this.role,
    this.bankAccountInfo,
    this.lastAccessDate, // Thêm vào constructor
  });

  factory MemberModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return MemberModel(
      id: doc.id,
      name: data?['name'] ?? '',
      avatarUrl: data?['avatarUrl'],
      description: data?['description'],
      totalExpenseAmount:
          (data?['totalExpenseAmount'] as num?)?.toDouble() ?? 0.0,
      balance: (data?['balance'] as num?)?.toDouble() ?? 0.0,
      isIdentified: data?['isIdentified'] ?? false,
      role: data?['role'] ?? '',
      bankAccountInfo: data?['bankAccountInfo'],
      lastAccessDate: data?['lastAccessDate'] != null
          ? (data?['lastAccessDate'] as Timestamp).toDate()
          : null, // Chuyển đổi Timestamp thành DateTime
    );
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatarUrl: map['avatarUrl'],
      description: map['description'],
      totalExpenseAmount:
          (map['totalExpenseAmount'] as num?)?.toDouble() ?? 0.0,
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      isIdentified: map['isIdentified'] ?? false,
      role: map['role'] ?? '',
      bankAccountInfo: map['bankAccountInfo'],
      lastAccessDate: map['lastAccessDate'] != null
          ? (map['lastAccessDate'] as Timestamp).toDate()
          : null, // Chuyển đổi Timestamp thành DateTime
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'description': description,
      'totalExpenseAmount': totalExpenseAmount,
      'balance': balance,
      'isIdentified': isIdentified,
      'role': role,
      'bankAccountInfo': bankAccountInfo,
      'lastAccessDate': lastAccessDate != null
          ? Timestamp.fromDate(lastAccessDate!)
          : null, // Chuyển đổi DateTime thành Timestamp
    };
  }

  MemberModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? description,
    double? totalExpenseAmount,
    double? balance,
    bool? isIdentified,
    String? role,
    String? bankAccountInfo,
    DateTime? lastAccessDate,
  }) {
    return MemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      description: description ?? this.description,
      totalExpenseAmount: totalExpenseAmount ?? this.totalExpenseAmount,
      balance: balance ?? this.balance,
      isIdentified: isIdentified ?? this.isIdentified,
      role: role ?? this.role,
      bankAccountInfo: bankAccountInfo ?? this.bankAccountInfo,
      lastAccessDate: lastAccessDate ?? this.lastAccessDate,
    );
  }
}
