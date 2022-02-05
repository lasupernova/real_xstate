import 'dart:math';
import 'dart:core';

class CashflowItem {
  // const PropertyItem({Key? key}) : super(key: key);
  String id;
  double mortgage;
  double propMngmtPerc;
  double vacancyLossPerc;
  double capitalExpPerc;
  double propMgmt;
  double vacancyLoss;
  double capitalExp;
  List rents;
  final double offer;
  final double downpayment;
  final double interest;
  final int term;
  final DateTime calcDate;

  CashflowItem({
    this.id = "not given",
    this.mortgage = 0,
    this.propMngmtPerc = 0.09,
    this.vacancyLossPerc = 0.05,
    this.capitalExpPerc = 0.05,
    this.propMgmt = 0,
    this.vacancyLoss = 0,
    this.capitalExp = 0,
    this.rents = const [],
    required this.offer,
    required this.downpayment,
    required this.interest,
    required this.term,
    required this.calcDate,
    // ignore: non_constant_identifier_names
    // required this.datetime = DateTime.now(),
  });
// Calculates monthly mortage payment [M] based [ offer - offer made for property ],
// [ downpayment - already made ], [ interest - interest rate on loan ] and
// [ term - total time (years) that loan will be running ].
// The total loan amount [ loanAmount ] iscalculated based on inputs for offer and downpayment
  // double calculateMortgage(
  //   double offer, // in $
  //   double downpayment, //in %
  //   double interest, // yearly in %
  //   int term, // in years --> calculation itself takes months, therefore if years are given term needs to be 'translated' into months
  // ) {
  //   double loanAmount = offer * (1 - downpayment / 100);
  //   interest = interest / 100 / 12; // convert to monthly interest rate
  //   term = term * 12; // convert to months
  //   double M = loanAmount *
  //       (interest * pow((1 + interest), term)) /
  //       (pow((1 + interest), term) - 1);
  //   mortgage = M;
  //   return M;
  // }

  void rentalAssocExpenses() {
    double totalRents = rents.fold(
        0,
        (previous, current) =>
            previous + current); // sum all values in list together
    propMgmt = totalRents * propMngmtPerc;
    vacancyLoss = totalRents * vacancyLossPerc;
    capitalExp = totalRents * capitalExpPerc;
    return;
  }
}
