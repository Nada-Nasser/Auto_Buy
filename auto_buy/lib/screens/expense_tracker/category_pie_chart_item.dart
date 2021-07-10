import 'package:charts_flutter/flutter.dart' as charts;

class CategoryPieChartItem {
  final String category;
  final double sales;
  final charts.Color color;

  CategoryPieChartItem(this.category, this.sales, this.color);
}
