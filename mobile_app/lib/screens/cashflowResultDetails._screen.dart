// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:mobile_app/widgets/cashflowResultTile.dart';
import 'package:provider/provider.dart';
import '../providers/cashflow_list.dart';
import '../models/cashflowResult.dart';
import '../widgets/cirleAvatarInfo.dart';

// called from cashflowResultTile.dart
class CfResultDetailsScreen extends StatefulWidget {
  static const routeName = "/cashflow_details";

  @override
  State<CfResultDetailsScreen> createState() => _CfResultDetailsScreenState();
}

class _CfResultDetailsScreenState extends State<CfResultDetailsScreen> {
  late final String cashflowID;
  late CashflowItem CF_item;
  bool _firstInit = true;

  @override
  void didChangeDependencies() {
    if (_firstInit) {
      cashflowID = ModalRoute.of(context)!.settings.arguments as String;
      CF_item = Provider.of<CashflowList>(context, listen: false)
          .findById(cashflowID.toString());
      _firstInit = !_firstInit;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width;
    double _screenheight = MediaQuery.of(context).size.height.toDouble();
    return Scaffold(
        appBar: AppBar(
          title: Text("Cashflow Details"),
          // toolbarOpacity: 0.8,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
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
              // wrap this in SingleChildScrollVIew
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Text(
                        "${CF_item.id}",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${DateFormat('yy-MM-dd').format(CF_item.calcDate)}",
                          ),
                          Text(
                              ""), // TODO: find more elegant solution for pushing text to the top
                          Text(""),
                          Text(""),
                          Text(""),
                        ],
                      ),
                    ),
                  ],
                ),
                // const Spacer(),
                Row(children: [
                  CircleAvatarInfo(
                      text1: CF_item.term.toString(), text2: "years"),
                  const Spacer(),
                  CircleAvatarInfo(
                      text1: CF_item.interest.toString(), text2: "%"),
                  const Spacer(),
                  CircleAvatarInfo(
                      text1: CF_item.offer < 10000
                          ? "\$${(CF_item.offer).toString().split(".")[0]}"
                          : CF_item.offer < 1000000
                              ? "\$${(CF_item.offer / 1000).toString()}k"
                              : "\$${(CF_item.offer / 1000000).toString()}M",
                      text2: "offer"),
                  const Spacer(),
                  CircleAvatarInfo(
                      text1: "${CF_item.downpayment.toString()} %",
                      text2: "down"),
                ]),
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text(
                    CF_item.mortgage.toStringAsFixed(2),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  subtitle: Text("Monthly Mortgage"),
                ),
                SizedBox(
                  height: _screenheight * 0.03,
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Container(
                      width: _screenwidth * 0.9,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.red)),
                      child: Table(
                        children: [
                          TableRow(children: [
                            Text("          "),
                            Text(
                              "Real",
                              textScaleFactor: 1.5,
                            ),
                            Text(
                              "Hypo",
                              textScaleFactor: 1.5,
                            ),
                          ]),
                          TableRow(
                              children: [Text("Income"), Text(""), Text("")]),
                          TableRow(children: [
                            Text("Net Operating"),
                            Text(CF_item.monthlyNetOpIncomeReal.toString()),
                            Text(CF_item.monthlyNetOpIncomeHypo.toString()),
                          ]),
                          TableRow(
                              children: [Text("Expenses"), Text(""), Text("")]),
                          TableRow(children: [
                            Text("Net Operating"),
                            Text(CF_item.monthlyNetOpCostsReal.toString()),
                            Text(CF_item.monthlyNetOpCostsHypo.toString()),
                          ]),
                          TableRow(children: [
                            Text("Total Monthly (incl. mortgage)"),
                            Text(CF_item.monthlyExpensesReal.toString()),
                            Text(CF_item.monthlyExpensesHypo.toString()),
                          ]),
                          TableRow(children: [
                            Text("Cashflow Stats"),
                            Text(""),
                            Text("")
                          ]),
                          TableRow(children: [
                            Text("Cashflow"),
                            Text(CF_item.cashflowMonthlyReal.toString()),
                            Text(CF_item.cashflowMonthlyHypo.toString()),
                          ]),
                          TableRow(children: [
                            Text("coc ROI"),
                            Text(CF_item.cocROIReal.toString()),
                            Text(CF_item.cocROIHypo.toString()),
                          ]),
                          TableRow(children: [
                            Text("Rent-to-Price ratio"),
                            Text(CF_item.rentToPrice.toString()),
                            Text(CF_item.rentToPrice.toString()),
                          ]),
                          TableRow(children: [
                            Text("CAP Rate"),
                            Text(CF_item.capRateReal.toString()),
                            Text(CF_item.capRateHypo.toString()),
                          ]),
                          TableRow(children: [
                            Text("ROI"),
                            Text(CF_item.rtiReal.toString()),
                            Text(CF_item.rtiHypo.toString()),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  // added in order to restrict height of Expanded() widget above to desired heigth (defined via flex)
                  child: SizedBox(
                    height: _screenheight * 0.1,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      print("Added to favorites");
                    },
                    icon: Icon(Icons.star_border_outlined))
              ],
            ),
          ),
        ));
  }
}
