import 'package:flutter/material.dart';

import 'Categories_expenses_pie_chart.dart';
import 'monthly_expenses_line_chart.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  @override
  _ExpenseTrackerScreenState createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  Future myFuture;

  @override
  void initState() {
    myFuture = null; // TODO , ADD FUNCTION TO FETCH ORDERS
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: myFuture,
          builder: (_, __) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  bottom: TabBar(
                    labelColor: Colors.white,
                    tabs: [Tab(text: 'Per Category'), Tab(text: 'Per Month')],
                  ),
                  title: Text('Expenses Tracker',
                      style: TextStyle(color: Colors.white)),
                  elevation: 0.1,
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: TabBarView(
                  children: [
                    CategoriesExpensesPieChart.withSampleData(),
                    MonthlyExpensesLineChart.withSampleData(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

