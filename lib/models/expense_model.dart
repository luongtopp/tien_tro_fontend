import 'package:cloud_firestore/cloud_firestore.dart';
import 'member_model.dart';

class ExpenseModel {
  final String groupId; // Changed from id to groupId
  final String title;
  final String note;
  final double amount;
  final DateTime createdDate;
  final DateTime date;
  final bool isPaid;
  final ExpenseMember byPeople;
  final List<ExpenseMember> forPeople;
  final String transactionType;
  final List<String>? photos; // Changed to nullable

  ExpenseModel({
    required this.groupId, // Changed from id to groupId
    required this.title,
    required this.note,
    required this.amount,
    required this.createdDate,
    required this.date,
    required this.byPeople,
    required this.forPeople,
    required this.transactionType,
    this.photos, // Changed to optional
    required this.isPaid,
  });

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      groupId: doc.id, // Changed from id to groupId
      title: data['title'] ?? '',
      note: data['note'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      createdDate: (data['createdDate'] as Timestamp).toDate(),
      date: (data['date'] as Timestamp).toDate(),
      byPeople: ExpenseMember.fromMap(
          data['byPeople'] as Map<String, dynamic>), // Changed
      forPeople: (data['forPeople'] as List<dynamic>)
          .map((e) => ExpenseMember.fromMap(e as Map<String, dynamic>))
          .toList(),
      transactionType: data['transactionType'] ?? '',
      photos: (data['photos'] as List<dynamic>?)?.cast<String>(), // Changed
      isPaid: data['isPaid'] ?? false,
    );
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      groupId: map['groupId'] ?? '', // Changed from id to groupId
      title: map['title'] ?? '',
      note: map['note'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      createdDate: (map['createdDate'] as Timestamp).toDate(),
      date: (map['date'] as Timestamp).toDate(),
      byPeople: ExpenseMember.fromMap(map['byPeople'] as Map<String, dynamic>),
      forPeople: (map['forPeople'] as List<dynamic>)
          .map((e) => ExpenseMember.fromMap(e as Map<String, dynamic>))
          .toList(),
      transactionType: map['transactionType'] ?? '',
      photos: (map['photos'] as List<dynamic>?)?.cast<String>(), // Changed
      isPaid: map['isPaid'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId, // Added groupId to the map
      'title': title,
      'note': note,
      'amount': amount,
      'createdDate': Timestamp.fromDate(createdDate),
      'date': Timestamp.fromDate(date),
      'byPeople':
          byPeople.toMap(), // Changed from .map((e) => e.toMap()).toList()
      'forPeople': forPeople.map((e) => e.toMap()).toList(),
      'transactionType': transactionType,
      'photos': photos,
      'isPaid': isPaid,
    };
  }
}

class ExpenseMember extends MemberModel {
  final double balance;
  final bool? isEdited;

  ExpenseMember({
    required String id,
    required String name,
    String? avatarUrl,
    required this.balance,
    this.isEdited,
  }) : super(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          totalExpenseAmount: 0,
          balance: 0,
          isIdentified: true,
          role: '',
        );

  factory ExpenseMember.fromMap(Map<String, dynamic> map) {
    return ExpenseMember(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatarUrl: map['avatarUrl'],
      balance: (map['balance'] as num).toDouble(),
      isEdited: map['isEdited'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'balance': balance,
      'isEdited': isEdited,
    };
  }
}
