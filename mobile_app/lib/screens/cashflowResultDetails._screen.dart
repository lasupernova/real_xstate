import 'package:flutter/material.dart';
import 'dart:math';

import 'package:mobile_app/widgets/cashflowResultTile.dart';
import 'package:provider/provider.dart';
import '../providers/cashflow_list.dart';
import '../models/cashflowResult.dart';

// called from cashflowResultTile.dart
class CfResultDetailsScreen extends StatelessWidget {
  static const routeName = "/cashflow_details";

  // double calculateMortgage(
  //   offer, // in $
  //   downpayment, //in %
  //   interest, // yearly in %
  //   term, // in years --> calculation itself takes months, therefore if years are given term needs to be 'translated' into months
  // ) {
  //   double loanAmount = offer * (1 - downpayment / 100);
  //   interest = interest / 100 / 12; // convert to monthly interest rate
  //   term = term * 12; // convert to months
  //   double M = loanAmount *
  //       (interest * pow((1 + interest), term)) /
  //       (pow((1 + interest), term) - 1);
  //   return M;
  // }

  @override
  Widget build(BuildContext context) {
    final cashflowID = ModalRoute.of(context)?.settings.arguments as String;
    CashflowItem CF_item =
        Provider.of<CashflowList>(context, listen: false).findById(cashflowID);
    // final double term = routeArgs[0].toDouble();
    // final double interest = routeArgs[1];
    // final double offer = routeArgs[2].toDouble();
    // final double downpayment = routeArgs[3].toDouble();

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
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.6,
                alignment: Alignment.center,
                child: Consumer<CashflowList>(builder: (context, props, child) {
                  CashflowItem CF_item = props.findById(cashflowID);
                  return Text(
                    "Term: ${CF_item.term}, interest: ${CF_item.interest * 100}%, offer: ${CF_item.offer}, downpayment: ${CF_item.downpayment} --- Monthly Payment: \$${CF_item.mortgage} / month",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 10,
                    ),
                  );
                }),
              ),
              IconButton(
                  onPressed: () {
                    print("Added to favorites");
                  },
                  icon: Icon(Icons.star_border_outlined))
            ],
          ),
        ),
      ),
    );
  }
}
