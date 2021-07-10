import 'package:auto_buy/models/expense_model.dart';
import 'package:auto_buy/widgets/colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

import 'category_pie_chart_item.dart';
import 'expense_tracker_services.dart';

enum Months { Jan, Feb, Mar, Apr, Jun, Jul, Aug, Sep, Oct, Nov, Dec }

class ExpensesTrackerBloc {
  final uid;
  List<Expense> expenses = [];
  Map<int, double> expensesPerMonths;
  List<CategoryPieChartItem> categoryPieChartItems = [];
  final ExpenseTrackerServices _services = ExpenseTrackerServices();

  ExpensesTrackerBloc({@required this.uid});

  Future<void> fetchUserExpenses() async {
    expenses = await _services.fetchAllUserExpenses(uid);
    _filterBasedOnCategories();
  }

  void _filterBasedOnCategories() {
    Map<String, double> map = {};
    print(expenses[0].categoryAndPrice);
    for (int i = 0; i < expenses.length; i++) {
      expenses[i].categoryAndPrice.forEach((k, v) {
        if (map[k] != null)
          map[k] += v;
        else
          map[k] = v;
      });
    }
    int i = 0;
    map.forEach((key, value) {
      CategoryPieChartItem item = CategoryPieChartItem(
          key, value, charts.ColorUtil.fromDartColor(colors[i]));
      i++;
      categoryPieChartItems.add(item);
    });
  }
}
