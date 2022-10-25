import 'package:flutter/material.dart';
import '../models/cashflowResult.dart';
import '../../providers/cashflow_list.dart';

class CashflowInfo extends StatelessWidget {
  // const CashflowInfo({Key? key}) : super(key: key);
  CashflowItem CF_item;
  double _screenwidth;
  bool _monthly;

  CashflowInfo(this.CF_item, this._screenwidth, this._monthly);

  static const tableRowTextStyle = TextStyle(fontSize: 11);
  static const tableRowHeaderStyle =
      TextStyle(fontSize: 11, fontWeight: FontWeight.bold);

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
                  style: tableRowTextStyle,
                ),
                Text(""),
                Text("")
              ]),
              TableRow(children: [
                const Text(
                  "Net Operating",
                  style: tableRowTextStyle,
                ),
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
              const TableRow(children: [
                Text(
                  "Expenses",
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                  style: tableRowTextStyle,
                ),
                Text(""),
                Text("")
              ]),
              TableRow(children: [
                const Text(
                  "Net Operating",
                  style: tableRowTextStyle,
                ),
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
                const Text(
                  "Total Monthly (incl. mortgage)",
                  style: tableRowTextStyle,
                ),
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
              const TableRow(children: [
                Text(
                  "Cashflow Stats",
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                  style: tableRowTextStyle,
                ),
                Text(""),
                Text("")
              ]),
              TableRow(children: [
                const Text(
                  "Cashflow",
                  style: tableRowTextStyle,
                ),
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
                const Text(
                  "coc ROI",
                  style: tableRowTextStyle,
                ),
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
                const Text(
                  "Rent-to-Price ratio",
                  style: tableRowTextStyle,
                ),
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
                const Text(
                  "CAP Rate",
                  style: tableRowTextStyle,
                ),
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
                const Text(
                  "ROI",
                  style: tableRowTextStyle,
                ),
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
