import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/cashflowResult.dart';
import '../../widgets/graphs/simpleLineChart.dart';

class MortgageDetailScreen extends StatelessWidget {
  // name({Key? key}) : super(key: key);
  final CashflowItem CF_item;
  MortgageDetailScreen({required this.CF_item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financing Term"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    "Runtime: ${CF_item.term.toString()} years",
                    // "${CF_item.id}",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("!@#"),
                Container(
                  child: SimpleLineChart.withSampleData(),
                  height: 200,
                  width: 200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
