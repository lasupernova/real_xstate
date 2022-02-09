import 'dart:math';
import 'dart:core';
import 'dart:developer';

class CashflowItem {
  String id; // generated + returned by DB via provider/cashflow_list.addCF()
  double mortgage;
  double
      propMgmtPerc; // TODO: group values where sensible (e.g. combine all rent assoc expenses into a list, to nit clutter constructor)
  double vacancyLossPerc; // form input
  double capitalExpPerc; // form input
  double totalRents;
  double totalCosts;
  double propMgmt;
  double vacancyLoss;
  double capitalExp;
  double monthlyExpensesReal;
  double monthlyExpensesHypo;
  double monthlyNetOpCostsReal;
  double monthlyNetOpCostsHypo;
  double monthlyNetOpIncomeReal;
  double monthlyNetOpIncomeHypo;
  double cashflowMonthlyReal;
  double cashflowMonthlyHypo;
  double totalInvestment;
  double cocROIReal;
  double cocROIHypo;
  double rentToPrice;
  double capRateReal;
  double capRateHypo;
  double rtiReal;
  double rtiHypo;
  double legal; // form input
  double homeInsp; // form input
  double propMgmtSignUp; // form input
  double bankFees; // form input
  List rents; // form input
  List costs; // form inout
  final double offer; // form input
  final double downpayment; // form input
  double downpaymentNum;
  final double interest; // form input
  final int term; // form imput
  final DateTime calcDate; // automatically generated in form screen

  CashflowItem({
    this.id = "not given",
    this.mortgage = 0,
    this.propMgmtPerc = 0.09,
    this.vacancyLossPerc = 0.05,
    this.capitalExpPerc = 0.05,
    this.totalRents = 0,
    this.totalCosts = 0,
    this.propMgmt = 0,
    this.vacancyLoss = 0,
    this.capitalExp = 0,
    this.monthlyExpensesReal = 0,
    this.monthlyExpensesHypo = 0,
    this.monthlyNetOpCostsReal = 0,
    this.monthlyNetOpCostsHypo = 0,
    this.monthlyNetOpIncomeReal = 0,
    this.monthlyNetOpIncomeHypo = 0,
    this.cashflowMonthlyReal = 0,
    this.cashflowMonthlyHypo = 0,
    this.totalInvestment = 0,
    this.cocROIReal = 0,
    this.cocROIHypo = 0,
    this.rentToPrice = 0,
    this.capRateReal = 0,
    this.capRateHypo = 0,
    this.rtiReal = 0,
    this.rtiHypo = 0,
    this.legal = 0,
    this.homeInsp = 0,
    this.propMgmtSignUp = 0,
    this.bankFees = 0,
    this.rents = const [],
    this.costs = const [],
    required this.offer,
    required this.downpayment,
    this.downpaymentNum = 0,
    required this.interest,
    required this.term,
    required this.calcDate,
    // ignore: non_constant_identifier_names
    // required this.datetime = DateTime.now(),
  });

//  Calculates monthly mortage payment [M] based [ offer - offer made for property ],
// [ downpayment - already made ], [ interest - interest rate on loan ] and
// [ term - total time (years) that loan will be running ].
// The total loan amount [ loanAmount ] is calculated based on inputs for offer and downpayment
  void _calculateMortgage(
    double offer, // in $
    double downpayment, //in %
    double interest, // yearly in %
    int term, // in years --> calculation itself takes months, therefore if years are given term needs to be 'translated' into months
  ) {
    double loanAmount = offer * (1 - downpayment / 100);
    downpaymentNum = offer -
        loanAmount; // numerical (dollar) amount of downpayment, as calculated based on offer and downpayment percentage [downpayment]
    interest = interest / 100 / 12; // convert to monthly interest rate
    term = term * 12; // convert to months
    double M = loanAmount *
        (interest * pow((1 + interest), term)) /
        (pow((1 + interest), term) - 1);
    mortgage = M;
  }

  //  Calculates expenses that are based on total rental income, namely proeprty management costs,
  // potential vacancy losses and capital expenditures.
  // Calculations based on rental income [ rents ] and percentages from rents defined for each of these expenses.
  void _rentalAssocExpenses() {
    totalRents = rents.fold(
        0,
        (previous, current) =>
            previous + current); // sum all values in list together
    propMgmt = totalRents * propMgmtPerc;
    vacancyLoss = totalRents * vacancyLossPerc;
    capitalExp = totalRents * capitalExpPerc;
  }

//  Calculates total monthly expenses (hypo or 'real'), including:
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
    monthlyNetOpCostsReal = propMgmt + vacancyLoss + capitalExp + totalCosts;
    monthlyNetOpCostsHypo = propMgmt + totalCosts;
    monthlyExpensesReal = monthlyNetOpCostsReal + mortgage;
    monthlyExpensesHypo = monthlyNetOpCostsHypo + mortgage;
  }

  //  Returns monthly net operating income
  void _totalIncomeMonthly() {
    monthlyNetOpIncomeReal = totalRents - monthlyNetOpCostsReal;
    monthlyNetOpIncomeHypo = totalRents - monthlyNetOpCostsHypo;
  }

  //  Returns monthly cashflow
  void _calculateCashflow() {
    cashflowMonthlyReal = totalRents - monthlyExpensesReal;
    cashflowMonthlyHypo = totalRents - monthlyExpensesHypo;
  }

  void _totalInvestment() {
    totalInvestment =
        downpaymentNum + legal + homeInsp + propMgmtSignUp + bankFees;
  }

  // Calculates cash-on-cash-ROI (a percent value -- calculated in fraction form --> multiply with 100 to get % form).
  void _calculateCocRoi() {
    cocROIReal = (cashflowMonthlyReal * 12) / totalInvestment;
    cocROIHypo = (cashflowMonthlyHypo * 12) / totalInvestment;
  }

  // Calculates rent-to-price-ratio (a percent value -- calculated in fraction form --> multiply with 100 to get % form).
  void _calculateRentToPrice() {
    rentToPrice = totalRents / offer;
  }

  // Calculates cap-rate (a percent value -- calculated in fraction form --> multiply with 100 to get % form).
  // Calculated based on YEARLY mortgage and YEARLY cashflow
  void _calculateCapRate() {
    capRateReal = ((mortgage * 12) + (cashflowMonthlyReal * 12)) / offer;
    capRateHypo = ((mortgage * 12) + (cashflowMonthlyHypo * 12)) / offer;
  }

  // Calculates cap-rate (a percent value).
  // Calculated based on YEARLY mortgage and YEARLY cashflow
  void _calculateRTI() {
    rtiReal = totalInvestment / (cashflowMonthlyReal * 12);
    rtiHypo = totalInvestment / (cashflowMonthlyHypo * 12);
  }

  void getCashflow() {
    _calculateMortgage(offer, downpayment, interest, term);
    _rentalAssocExpenses();
    _totalExpensesMonthly();
    _totalIncomeMonthly();
    _calculateCashflow();
    _calculateCocRoi();
    _calculateRentToPrice();
    _calculateCapRate();
    inspect(this);
  }
}
