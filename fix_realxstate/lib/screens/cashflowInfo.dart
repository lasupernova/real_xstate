import 'package:flutter/material.dart';
import '../models/cashflowResult.dart';
import '../../providers/cashflow_list.dart';

class CashflowInfo extends StatelessWidget {
  // const CashflowInfo({Key? key}) : super(key: key);
  CashflowItem CF_item;
  double _screenwidth;
  bool _monthly;

  CashflowInfo(this.CF_item, this._screenwidth, this._monthly);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: SingleChildScrollView(
        child: Container(
          width: _screenwidth * 0.9,
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: Table(
            children: [
              TableRow(children: [
                Text("          "),
                Text(
                  "Real",
                  textScaleFactor: 1.7,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Hypo",
                  textScaleFactor: 1.7,
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Text(
                  "Income",
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                ),
                Text(""),
                Text("")
              ]),
              TableRow(children: [
                Text("Net Operating"),
                Text(
                  _monthly
                      ? CF_item.monthlyNetOpIncomeReal.toStringAsFixed(2)
                      : (CF_item.monthlyNetOpIncomeReal * 12)
                          .toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _monthly
                      ? CF_item.monthlyNetOpIncomeHypo.toStringAsFixed(2)
                      : (CF_item.monthlyNetOpIncomeHypo * 12)
                          .toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Text(
                  "Expenses",
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                ),
                Text(""),
                Text("")
              ]),
              TableRow(children: [
                Text("Net Operating"),
                Text(
                  _monthly
                      ? CF_item.monthlyNetOpCostsReal.toStringAsFixed(2)
                      : (CF_item.monthlyNetOpCostsReal * 12).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _monthly
                      ? CF_item.monthlyNetOpCostsHypo.toStringAsFixed(2)
                      : (CF_item.monthlyNetOpCostsHypo * 12).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Text("Total Monthly (incl. mortgage)"),
                Text(
                  _monthly
                      ? CF_item.monthlyExpensesReal.toStringAsFixed(2)
                      : (CF_item.monthlyExpensesReal * 12).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _monthly
                      ? CF_item.monthlyExpensesHypo.toStringAsFixed(2)
                      : (CF_item.monthlyExpensesHypo * 12).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Text(
                  "Cashflow Stats",
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                ),
                Text(""),
                Text("")
              ]),
              TableRow(children: [
                Text("Cashflow"),
                Text(
                  _monthly
                      ? CF_item.cashflowMonthlyReal.toStringAsFixed(2)
                      : (CF_item.cashflowMonthlyReal * 12).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _monthly
                      ? CF_item.cashflowMonthlyHypo.toStringAsFixed(2)
                      : (CF_item.cashflowMonthlyHypo * 12).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Text("coc ROI"),
                Text(
                  (CF_item.cocROIReal * 100).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  (CF_item.cocROIHypo * 100).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Text("Rent-to-Price ratio"),
                Text(
                  (CF_item.rentToPrice * 100).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  (CF_item.rentToPrice * 100).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Text("CAP Rate"),
                Text(
                  (CF_item.capRateReal * 100).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  (CF_item.capRateHypo * 100).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Text("ROI"),
                Text(
                  CF_item.rtiReal.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  CF_item.rtiHypo.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
