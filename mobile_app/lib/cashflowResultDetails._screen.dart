import 'package:flutter/material.dart';
import 'dart:math';

import 'package:mobile_app/cashflowResultTile.dart';

class CfResultDetailsScreen extends StatelessWidget {
  static const routeName = "/cashflow_details";

  double calculateMortgage(
    offer,
    downpayment,
    interest,
    term,
  ) {
    double loanAmount = offer * (downpayment / 100);
    double M = loanAmount *
        (interest * pow((1 + interest), term)) /
        (pow((1 + interest), term) - 1);
    return M;
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as List<double>;
    final double term = routeArgs[0];
    final double interest = routeArgs[1];
    final double offer = routeArgs[2];
    final double downpayment = routeArgs[3];

    return Container(
      child: Center(
        child: Text(
            "Term: $term, interest: $interest, offer: $offer, downpayment: $downpayment --- Monthly Payment: $calculateMortgage(offer, downpayment, interest, term)"),
      ),
    );
  }
}
