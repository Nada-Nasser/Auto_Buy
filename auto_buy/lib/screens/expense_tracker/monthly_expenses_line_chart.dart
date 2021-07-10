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

        behaviors: [
          new charts.ChartTitle('Months',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification: charts.OutsideJustification.middle),
          new charts.ChartTitle('(\$)',
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification: charts.OutsideJustification.start),
          new charts.RangeAnnotation([
            buildLineAnnotationSegment("Jan", 1),
            buildLineAnnotationSegment("Feb", 2),
            buildLineAnnotationSegment("Mar", 3),
            buildLineAnnotationSegment("Apr", 4),
            buildLineAnnotationSegment("May", 5),
            buildLineAnnotationSegment("Jun", 6),
            buildLineAnnotationSegment("Jul", 7),
            buildLineAnnotationSegment("Aug", 8),
            buildLineAnnotationSegment("Sep", 9),
            buildLineAnnotationSegment("Oct", 10),
            buildLineAnnotationSegment("Nov", 11),
            buildLineAnnotationSegment("Dec", 12),
          ]),
        ],
      ),
    );
  }

  charts.LineAnnotationSegment<dynamic> buildLineAnnotationSegment(
      String month, int m) {
    DateTime now = new DateTime.now();
    return new charts.LineAnnotationSegment(
        new DateTime(now.year, m, 1), charts.RangeAnnotationAxisType.domain,
        labelPosition: charts.AnnotationLabelPosition.outside,
        color: charts.ColorUtil.fromDartColor(Colors.blueGrey[100]),
        middleLabel: month);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2021, 1, 1), 5),
      new TimeSeriesSales(new DateTime(2021, 2, 1), 25),
      new TimeSeriesSales(new DateTime(2021, 3, 1), 100),
      new TimeSeriesSales(new DateTime(2021, 4, 1), 75),
      new TimeSeriesSales(new DateTime(2021, 5, 1), 20),
      new TimeSeriesSales(new DateTime(2021, 6, 1), 100),
      new TimeSeriesSales(new DateTime(2021, 7, 1), 75),
      new TimeSeriesSales(new DateTime(2021, 8, 1), 200),
      new TimeSeriesSales(new DateTime(2021, 9, 1), 100),
      new TimeSeriesSales(new DateTime(2021, 10, 1), 90),
      new TimeSeriesSales(new DateTime(2021, 11, 1), 90),
      new TimeSeriesSales(new DateTime(2021, 12, 1), 90),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
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
