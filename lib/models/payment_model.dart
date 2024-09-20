import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String id;
  final String payerId;
  final Map<String, double> receivers; // Thay đổi này
  final double totalAmount;
  final DateTime date;
  final String? description;

  const PaymentModel({
    required this.id,
    required this.payerId,
    required this.receivers,
    required this.totalAmount,
    required this.date,
    this.description,
  });

  @override
  List<Object?> get props =>
      [id, payerId, receivers, totalAmount, date, description];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'payerId': payerId,
      'receivers': receivers,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] as String,
      payerId: map['payerId'] as String,
      receivers: Map<String, double>.from(map['receivers'] as Map),
      totalAmount: map['totalAmount'] as double,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String?,
    );
  }
}
