import 'dart:math';
import 'dart:core';

class CashflowItem {
  // const PropertyItem({Key? key}) : super(key: key);
  String id;
  double mortgage;
  double
      propMgmtPerc; // TODO: group values where sensible (e.g. combine all rent assoc expenses into a list, to nit clutter constructor)
  double vacancyLossPerc;
  double capitalExpPerc;
  double propMgmt;
  double vacancyLoss;
  double capitalExp;
  double monthlyExpensesReal;
  double monthlyExpensesHypo;
  double monthlyNetOpCostsReal;
  double monthlyNetOpCostsHypo;
  List rents;
  List costs;
  final double offer;
  final double downpayment;
  final double interest;
  final int term;
  final DateTime calcDate;

  CashflowItem({
    this.id = "not given",
    this.mortgage = 0,
    this.propMgmtPerc = 0.09,
    this.vacancyLossPerc = 0.05,
    this.capitalExpPerc = 0.05,
    this.propMgmt = 0,
    this.vacancyLoss = 0,
    this.capitalExp = 0,
    this.monthlyExpensesReal = 0,
    this.monthlyExpensesHypo = 0,
    this.monthlyNetOpCostsReal = 0,
    this.monthlyNetOpCostsHypo = 0,
    this.rents = const [],
    this.costs = const [],
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

  // Calculates expenses that are based on total rental income, namely proeprty management costs,
  // potential vacancy losses and capital expenditures.
  // Calculations based on rental income [ rents ] and percentages from rents defined for each of these expenses.
  void rentalAssocExpenses() {
    double totalRents = rents.fold(
        0,
        (previous, current) =>
            previous + current); // sum all values in list together
    propMgmt = totalRents * propMgmtPerc;
    vacancyLoss = totalRents * vacancyLossPerc;
    capitalExp = totalRents * capitalExpPerc;
    return;
  }

// Calculates total monthly expenses (hypo or 'real'), including:
// total monthly expeneses [ monthlyExpenses ] (INCLUDES mortgage payments)
// total monthly net operating costs [ monthlyNetOpCosts ] (EXCLUDES mortgage payments)
// .
// Calculations based on rental income [ rents ], recurring non-rental associated costs [ costs ] (utilities, taxes, HOA, insurance...),
// monthly mortgage [ mortage ]
  void _totalExpensesMonthly() {
    double totalCosts = costs.fold(
        0,
        (previous, current) =>
            previous + current); // sum all values in list together
    monthlyNetOpCostsReal = propMgmt + totalCosts;
    monthlyNetOpCostsHypo = propMgmt + vacancyLoss + capitalExp + totalCosts;
    monthlyExpensesReal = monthlyNetOpCostsReal + mortgage;
    monthlyExpensesHypo = monthlyNetOpCostsHypo + mortgage;
  }
}
