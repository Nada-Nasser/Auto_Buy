import 'package:auto_buy/screens/expense_tracker/expense_tracker_screen.dart';
import 'package:flutter/material.dart';

import 'command.dart';

class ExpenseTrackerCommand implements Command {
  @override
  final CommandArguments commandArguments;

  ExpenseTrackerCommand(this.commandArguments);

  @override
  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;

  @override
  Future<void> run() async {
    if (commandArguments.commandType == CommandType.OPEN) {
      await _openExpenseTracker();
    } else {
      throw Exception("unknown command type in Expense Tracker");
    }
  }

  _openExpenseTracker() {
    Navigator.of(commandArguments.context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ExpenseTrackerScreen.create(context),
      ),
    );
  }
}
