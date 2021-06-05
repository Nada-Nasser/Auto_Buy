import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class CategoriesExpensesPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CategoriesExpensesPieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory CategoriesExpensesPieChart.withSampleData() {
    return CategoriesExpensesPieChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: charts.PieChart(
          seriesList,
          animate: true,
          animationDuration: const Duration(
            seconds: 1,
          ),
          defaultRenderer: new charts.ArcRendererConfig(
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.auto)
            ],
          ),
          behaviors: [
            new charts.DatumLegend(
              // Positions for "start" and "end" will be left and right respectively
              // for widgets with a build context that has directionality ltr.
              // For rtl, "start" and "end" will be right and left respectively.
              // Since this example has directionality of ltr, the legend is
              // positioned on the right side of the chart.
              position: charts.BehaviorPosition.bottom,
              // By default, if the position of the chart is on the left or right of
              // the chart, [horizontalFirst] is set to false. This means that the
              // legend entries will grow as new rows first instead of a new column.
              horizontalFirst: false,
              // This defines the padding around each legend entry.
              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
              // Set [showMeasures] to true to display measures in series legend.
              showMeasures: true,
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

  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      LinearSales(0, 5, charts.ColorUtil.fromDartColor(Colors.purple[100])),
      LinearSales(1, 20, charts.ColorUtil.fromDartColor(Color(0xFF522210))),
      LinearSales(2, 75, charts.ColorUtil.fromDartColor(Color(0xFF929910))),
      LinearSales(3, 100, charts.ColorUtil.fromDartColor(Color(0xFFD26699))),
    ];

    return [
      new charts.Series<LinearSales, int>(
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
  final int year;
  final int sales;
  final charts.Color color;

  LinearSales(this.year, this.sales, this.color);
}
