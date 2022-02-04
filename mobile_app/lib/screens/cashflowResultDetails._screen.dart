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
      print("GETTING CASHFLOW ID");
      cashflowID = ModalRoute.of(context)!.settings.arguments as String;
      CF_item = Provider.of<CashflowList>(context, listen: false)
          .findById(cashflowID.toString());
      _firstInit = !_firstInit;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.03,
                          horizontal: MediaQuery.of(context).size.width * 0.03),
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  text1: CF_item.term.toString(),
                                  text2: "years"),
                              const Spacer(),
                              CircleAvatarInfo(
                                  text1: CF_item.interest.toString(),
                                  text2: "%"),
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
                            IconButton(
                                onPressed: () {
                                  print("Added to favorites");
                                },
                                icon: Icon(Icons.star_border_outlined))
                          ])),
                ),
              ],
            ),
          ),
        ));
  }
}
