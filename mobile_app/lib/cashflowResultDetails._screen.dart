import 'package:flutter/material.dart';
import 'dart:math';

import 'package:mobile_app/cashflowResultTile.dart';

// called from cashflowResultTile.dart
class CfResultDetailsScreen extends StatelessWidget {
  static const routeName = "/cashflow_details";

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

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as List;
    final double term = routeArgs[0].toDouble();
    final double interest = routeArgs[1];
    final double offer = routeArgs[2].toDouble();
    final double downpayment = routeArgs[3].toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text("Cashflow Details"),
        actions: <Widget>[
          IconButton(
            onPressed: () => print("EXPORTED"),
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text(
            "Term: $term, interest: ${interest * 100}%, offer: $offer, downpayment: $downpayment --- Monthly Payment: ${calculateMortgage(offer, downpayment, interest, term).toString()}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
