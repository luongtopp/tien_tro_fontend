import 'package:cloud_firestore/cloud_firestore.dart';

import 'member.dart';

class GroupModel {
  final String? id;
  final String name;
  final String description;
  final String code;
  final String ownerId;
  final String ownerUserId;
  final bool isActive;
  final bool isReceiveNotification;
  final String type;
  final String creator;
  final DateTime createdDate;
  final List<Member> members;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.ownerId,
    required this.ownerUserId,
    required this.isActive,
    required this.isReceiveNotification,
    required this.type,
    required this.creator,
    required this.createdDate,
    required this.members,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      code: data['code'],
      ownerId: data['ownerId'],
      ownerUserId: data['ownerUserId'],
      isActive: data['isActive'],
      isReceiveNotification: data['isReceiveNotification'],
      type: data['type'],
      creator: data['creator'],
      createdDate: (data['createdDate'] as Timestamp)
          .toDate(), // Chuyển đổi Timestamp sang DateTime
      members: (data['members'] as List<dynamic>?)
              ?.map((item) => Member.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'ownerId': ownerId,
      'ownerUserId': ownerUserId,
      'isActive': isActive,
      'isReceiveNotification': isReceiveNotification,
      'type': type,
      'creator': creator,
      'createdDate': createdDate, // Thêm vào toMap
      'members': members
          .map((member) => member.toMap())
          .toList(), // Chuyển đổi danh sách Member thành danh sách map
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? code,
    String? ownerId,
    String? ownerUserId,
    bool? isActive,
    bool? isReceiveNotification,
    String? type,
    String? creator,
    DateTime? createdDate,
    List<Member>? members,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      ownerId: ownerId ?? this.ownerId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      isActive: isActive ?? this.isActive,
      isReceiveNotification:
          isReceiveNotification ?? this.isReceiveNotification,
      type: type ?? this.type,
      creator: creator ?? this.creator,
      createdDate: createdDate ?? this.createdDate,
      members: members ?? this.members,
    );
  }
}
