import 'package:auto_buy/models/expense_model.dart';
import 'package:auto_buy/screens/expense_tracker/invoices_view.dart';
import 'package:auto_buy/widgets/colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

import 'TimeSeriesExpenses.dart';
import 'category_pie_chart_item.dart';
import 'expense_tracker_services.dart';

enum Months { Jan, Feb, Mar, Apr, Jun, Jul, Aug, Sep, Oct, Nov, Dec }

class ExpensesTrackerBloc {
  final uid;
  List<Expense> expenses = [];
  Map<int, double> expensesPerMonths;
  List<CategoryPieChartItem> categoryPieChartItems = [];
  List<TimeSeriesExpenses> timeSeriesExpenses = [];

  final ExpenseTrackerServices _services = ExpenseTrackerServices();

  List<Invoice> invoices = [];

  ExpensesTrackerBloc({@required this.uid});

  Future<void> fetchUserExpenses() async {
    expenses = await _services.fetchAllUserExpenses(uid);
    _filterBasedOnCategories();
  }

  void _filterBasedOnCategories() {
    DateTime now = new DateTime.now();
    DateTime yearAgo = new DateTime(now.year - 1, now.month, now.day);

    Map<String, double> map = {};
    for (int i = 0; i < expenses.length; i++) {
      int revisedIndex = expenses.length - 1 - i;
      List<InvoiceEntry> entries =
          _createInvoiceEntries(expenses[revisedIndex]);
      Invoice invoice = Invoice(
        expenses[revisedIndex].totalPrice,
        expenses[revisedIndex].date,
        entries,
      );
      invoices.add(invoice);

      if (expenses[i].date.isAfter(yearAgo)) {
        print(
            "_filterBasedOnCategories: ${expenses[i]} added to the monthly tracker");
        timeSeriesExpenses
            .add(TimeSeriesExpenses(expenses[i].date, expenses[i].totalPrice));
      }
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

  List<InvoiceEntry> _createInvoiceEntries(Expense expense) {
    List<InvoiceEntry> output = [];
    List<dynamic> ids = expense.productsID;
    for (int i = 0; i < ids.length; i++) {
      String name = expense.productsName[i];
      int quantity = expense.quantities[ids[i]];
      double price = expense.prices[ids[i]];
      output.add(InvoiceEntry(name, price, quantity));
    }

    return output;
  }
}
