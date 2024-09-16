import 'package:cloud_firestore/cloud_firestore.dart';

import 'member_model.dart';
import 'expense_model.dart';

class GroupModel {
  final String? id;
  final String name;
  final String description;
  final String code;
  final String ownerId;
  final bool isActive;
  final bool isReceiveNotification;
  final String type;
  final String creator;
  final DateTime createdDate;
  final List<MemberModel> members;
  final int memberCount;
  final List<ExpenseModel> expenses;

  GroupModel({
    this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.ownerId,
    required this.isActive,
    required this.isReceiveNotification,
    required this.type,
    required this.creator,
    required this.createdDate,
    required this.members,
    required this.memberCount,
    required this.expenses,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;
      return GroupModel(
        id: doc.id,
        name: data['name'] as String,
        description: data['description'] as String,
        code: data['code'] as String,
        ownerId: data['ownerId'] as String,
        isActive: data['isActive'] as bool,
        isReceiveNotification: data['isReceiveNotification'] as bool,
        type: data['type'] as String,
        creator: data['creator'] as String,
        createdDate: (data['createdDate'] as Timestamp).toDate(),
        members: (data['members'] as List<dynamic>?)
                ?.map(
                    (item) => MemberModel.fromMap(item as Map<String, dynamic>))
                .toList() ??
            [],
        memberCount: data['memberCount'] as int? ?? 0,
        expenses: (data['expenses'] as List<dynamic>?)
                ?.map((item) =>
                    ExpenseModel.fromMap(item as Map<String, dynamic>))
                .toList() ??
            [],
      );
    } on Exception catch (e) {
      throw Exception('Lỗi tạo nhóm từ firestore: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'code': code,
      'ownerId': ownerId,
      'isActive': isActive,
      'isReceiveNotification': isReceiveNotification,
      'type': type,
      'creator': creator,
      'createdDate': Timestamp.fromDate(createdDate),
      'members': members.map((member) => member.toMap()).toList(),
      'memberCount': memberCount,
      'expenses': expenses.map((expense) => expense.toMap()).toList(),
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? code,
    String? ownerId,
    bool? isActive,
    bool? isReceiveNotification,
    String? type,
    String? creator,
    DateTime? createdDate,
    List<MemberModel>? members,
    int? memberCount,
    List<ExpenseModel>? expenses,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      ownerId: ownerId ?? this.ownerId,
      isActive: isActive ?? this.isActive,
      isReceiveNotification:
          isReceiveNotification ?? this.isReceiveNotification,
      type: type ?? this.type,
      creator: creator ?? this.creator,
      createdDate: createdDate ?? this.createdDate,
      members: members ?? this.members,
      memberCount: memberCount ?? this.memberCount,
      expenses: expenses ?? this.expenses,
    );
  }
}
