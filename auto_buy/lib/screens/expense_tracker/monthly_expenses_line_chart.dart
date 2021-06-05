import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class MonthlyExpensesLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MonthlyExpensesLineChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory MonthlyExpensesLineChart.withSampleData() {
    return new MonthlyExpensesLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 2),
      child: charts.TimeSeriesChart(
        seriesList,
        animate: true,
        animationDuration: const Duration(
          seconds: 1,
        ),
        // Optionally pass in a [DateTimeFactory] used by the chart. The factory
        // should create the same type of [DateTime] as the data provided. If none
        // specified, the default creates local date time.
        dateTimeFactory: const charts.LocalDateTimeFactory(),
/*
        primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(
              // Tick and Label styling here.
            )),
*/
        behaviors: [
          /*    new charts.ChartTitle('Your Expenses(\$)',
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification: charts.OutsideJustification.start,
              // Set a larger inner padding than the default (10) to avoid
              // rendering the text too close to the top measure axis tick label.
              // The top tick label may extend upwards into the top margin region
              // if it is located at the top of the draw area.
              ),
*/
          new charts.ChartTitle('Months',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
          new charts.ChartTitle('Your Expenses(\$)',
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
        ],
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 1, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 2, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 3, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 4, 10), 75),
      new TimeSeriesSales(new DateTime(2018, 5, 10), 20),
      new TimeSeriesSales(new DateTime(2019, 7, 10), 200),
      new TimeSeriesSales(new DateTime(2020, 8, 10), 100),
      new TimeSeriesSales(new DateTime(2020, 8, 10), 90),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        // When the measureLowerBoundFn and measureUpperBoundFn is defined,
        // the line renderer will render the area around the bounds.
        measureLowerBoundFn: (TimeSeriesSales sales, _) => sales.sales - 5,
        measureUpperBoundFn: (TimeSeriesSales sales, _) => sales.sales + 5,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
