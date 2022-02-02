import 'package:intl/intl.dart';

class CashflowItem {
  // const PropertyItem({Key? key}) : super(key: key);
  String id;
  double mortgage;
  final double offer;
  final double downpayment;
  final double interest;
  final int term;
  final DateTime calcDate;

  CashflowItem({
    this.id = "not given",
    this.mortgage = 0,
    required this.offer,
    required this.downpayment,
    required this.interest,
    required this.term,
    required this.calcDate,
    // ignore: non_constant_identifier_names
    // required this.datetime = DateTime.now(),
  });
}
