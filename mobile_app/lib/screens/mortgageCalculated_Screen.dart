import 'package:flutter/material.dart';

import '../models/cashflowResult.dart';

class MortgageResult extends StatelessWidget {
  // const MortgageResult({Key? key}) : super(key: key);
  static const routeName = "/mortgage-result";

  @override
  Widget build(BuildContext context) {
    Map test = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        appBar: AppBar(
          title: Text("MORTGAGE"),
        ),
        body: Container(child: Text(test.toString())));
  }
}
