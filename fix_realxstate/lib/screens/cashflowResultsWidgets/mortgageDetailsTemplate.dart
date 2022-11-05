import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../models/cashflowResult.dart';
import '../../widgets/graphs/simpleLineChart.dart';

class MortgageDetailScreen extends StatelessWidget {
  // name({Key? key}) : super(key: key);
  final CashflowItem CF_item;
  MortgageDetailScreen({required this.CF_item});

  @override
  Widget build(BuildContext context) {
    List<MortgageSeries> list = [];
    CF_item.calculateAmortization().forEach(
        (key, value) => list.add(MortgageSeries(year: key, sales: value)));

    final charts.Series<MortgageSeries, int> serieslist =
        charts.Series<MortgageSeries, int>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
      domainFn: (MortgageSeries sales, _) => sales.year,
      measureFn: (MortgageSeries sales, _) => sales.sales,
      data: list,
    );

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
                  child: SimpleLineChart([serieslist], animate: true),
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
