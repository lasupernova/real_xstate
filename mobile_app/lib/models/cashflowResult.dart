import 'package:intl/intl.dart';

class CashflowResult {
  // const PropertyItem({Key? key}) : super(key: key);
  String id;
  final double mortgage;
  final double offer;
  final double downpayment;
  final double interest;
  final double term;
  // var datetime;

  CashflowResult({
    this.id = "not given",
    required this.mortgage,
    required this.offer,
    required this.downpayment,
    required this.interest,
    required this.term,
    // ignore: non_constant_identifier_names
    // required this.datetime = DateTime.now(),
  });
}
