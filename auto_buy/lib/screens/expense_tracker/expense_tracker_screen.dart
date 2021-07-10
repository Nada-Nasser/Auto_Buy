import 'package:auto_buy/screens/expense_tracker/expenses_tracker_bloc.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Categories_expenses_pie_chart.dart';
import 'monthly_expenses_line_chart.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  final ExpensesTrackerBloc bloc;

  const ExpenseTrackerScreen({Key key, this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Provider<ExpensesTrackerBloc>(
      create: (_) => ExpensesTrackerBloc(
        uid: auth.uid,
      ),
      child: Consumer<ExpensesTrackerBloc>(
        builder: (_, bloc, __) => ExpenseTrackerScreen(bloc: bloc),
      ),
    );
  }

  @override
  _ExpenseTrackerScreenState createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  Future myFuture;

  @override
  void initState() {
    final bloc = Provider.of<ExpensesTrackerBloc>(context, listen: false);
    myFuture = bloc.fetchUserExpenses();
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
                    CategoriesExpensesPieChart.withSampleData(context),
                    MonthlyExpensesLineChart.withSampleData(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

