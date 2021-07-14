import 'package:auto_buy/screens/expense_tracker/expenses_tracker_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TimeSeriesExpenses.dart';

class MonthlyExpensesLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MonthlyExpensesLineChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory MonthlyExpensesLineChart.withSampleData(BuildContext context) {
    return new MonthlyExpensesLineChart(
      _createSampleData(context),
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
          buildMonthsRangeAnnotation(context),
        ],
      ),
    );
  }

  charts.RangeAnnotation buildMonthsRangeAnnotation(BuildContext context) {
    final bloc = Provider.of<ExpensesTrackerBloc>(context, listen: false);
    final data = bloc.timeSeriesExpenses;

    List<charts.LineAnnotationSegment<dynamic>> l = [];

    for (int i = 0; i < data.length; i++) {
      String mY = _getMonthAndYear(data[i].time);

      l.add(buildLineAnnotationSegment(mY, data[i].time));
    }

    return new charts.RangeAnnotation(l);
  }

  charts.LineAnnotationSegment<dynamic> buildLineAnnotationSegment(
      String month, DateTime date) {
    DateTime now = new DateTime.now();
    return new charts.LineAnnotationSegment(
        date, charts.RangeAnnotationAxisType.domain,
        labelPosition: charts.AnnotationLabelPosition.outside,
        color: charts.ColorUtil.fromDartColor(Colors.blueGrey[100]),
        middleLabel: month);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesExpenses, DateTime>> _createSampleData(
      BuildContext context) {
    final bloc = Provider.of<ExpensesTrackerBloc>(context, listen: false);
    final data = bloc.timeSeriesExpenses;

    return [
      new charts.Series<TimeSeriesExpenses, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesExpenses sales, _) => sales.time,
        measureFn: (TimeSeriesExpenses sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  // mon,year
  // jun, 2020
  String _getMonthAndYear(DateTime time) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    String mon = months[time.month - 1];
    return "$mon, ${time.year}";
  }
}

