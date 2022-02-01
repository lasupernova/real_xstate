import 'dart:math';

double calculateMortgage(
  offer, // in $
  downpayment, //in %
  interest, // yearly in %
  term, // in years --> calculation itself takes months, therefore if years are given term needs to be 'translated' into months
) {
  double loanAmount = offer * (1 - downpayment / 100);
  interest = interest / 100 / 12; // convert to monthly interest rate
  term = term * 12; // convert to months
  double M = loanAmount *
      (interest * pow((1 + interest), term)) /
      (pow((1 + interest), term) - 1);
  return M;
}
