import 'package:flutter/material.dart';

import 'Categories_expenses_pie_chart.dart';
import 'monthly_expenses_line_chart.dart';

class ExpenseTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Colors.white,
              tabs: [
                Tab(text: 'Categories Expenses'),
                Tab(text: 'Monthly Expenses')
              ],
            ),
            title:
                Text('Expenses Tracker', style: TextStyle(color: Colors.white)),
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
      ),
    );
  }
}

