import 'package:intl/intl.dart';

String formattedAmount(double amount) {
  final formattedAmount =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(amount);
  return formattedAmount;
}
