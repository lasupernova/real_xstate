/// Simple line chart to visualize cashflow data.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {required this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData() {
    return new SimpleLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(seriesList, animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<MortgageSeries, num>> _createSampleData() {
    final data = [
      MortgageSeries(year: 0, sales: 5),
      MortgageSeries(year: 1, sales: 2),
      MortgageSeries(year: 2, sales: 10),
      MortgageSeries(year: 3, sales: 7),
    ];

    return [
      charts.Series<MortgageSeries, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MortgageSeries sales, _) => sales.year,
        measureFn: (MortgageSeries sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class MortgageSeries {
  final int year;
  final double sales;

  MortgageSeries({
    required this.year,
    required this.sales,
  });
}
