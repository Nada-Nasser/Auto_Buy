import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category_pie_chart_item.dart';
import 'expenses_tracker_bloc.dart';

class CategoriesExpensesPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CategoriesExpensesPieChart(this.seriesList, {this.animate});

  factory CategoriesExpensesPieChart.withSampleData(BuildContext context) {
    return CategoriesExpensesPieChart(
      _createSampleData(context),
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
                return value == null ? '-' : '${value} EGP';
              },
            ),
          ],
        ),
      ),
    );
  }

  static List<charts.Series<CategoryPieChartItem, String>> _createSampleData(
      BuildContext context) {
    final bloc = Provider.of<ExpensesTrackerBloc>(context, listen: false);
    final data = bloc.categoryPieChartItems;

    return [
      new charts.Series<CategoryPieChartItem, String>(
        id: 'Sales',
        domainFn: (CategoryPieChartItem sales, _) => sales.category,
        measureFn: (CategoryPieChartItem sales, _) => sales.sales,
        data: data,
        colorFn: (CategoryPieChartItem sales, _) => sales.color,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (CategoryPieChartItem row, _) =>
            '${row.category}: ${row.sales}',
      )
    ];
  }
}
