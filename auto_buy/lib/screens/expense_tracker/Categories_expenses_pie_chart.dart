import 'package:auto_buy/widgets/colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class CategoriesExpensesPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CategoriesExpensesPieChart(this.seriesList, {this.animate});

  factory CategoriesExpensesPieChart.withSampleData() {
    return CategoriesExpensesPieChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: charts.PieChart(
          seriesList,
          animate: animate,
          animationDuration: const Duration(
            seconds: 1,
          ),
          defaultRenderer: new charts.ArcRendererConfig(
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.auto,
              )
            ],
          ),
          behaviors: [
            new charts.DatumLegend(
              position: charts.BehaviorPosition.bottom,
              horizontalFirst: false,
              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
              showMeasures: true,
              desiredMaxRows: 6,
              // Configure the measure value to be shown by default in the legend.
              legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
              // Optionally provide a measure formatter to format the measure value.
              // If none is specified the value is formatted as a decimal.
              measureFormatter: (num value) {
                return value == null ? '-' : '${value}k';
              },
            ),
          ],
        ),
      ),
    );
  }

  static List<charts.Series<LinearSales, String>> _createSampleData() {
    final data = [
      LinearSales("Food", 5, charts.ColorUtil.fromDartColor(colors[0])),
      LinearSales("fruits", 20, charts.ColorUtil.fromDartColor(colors[1])),
      LinearSales("cats", 75, charts.ColorUtil.fromDartColor(colors[2])),
      LinearSales("goods", 100, charts.ColorUtil.fromDartColor(colors[3])),
      LinearSales("gg", 120, charts.ColorUtil.fromDartColor(colors[4])),
    ];

    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        colorFn: (LinearSales sales, _) => sales.color,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final int sales;
  final charts.Color color;

  LinearSales(this.year, this.sales, this.color);
}
