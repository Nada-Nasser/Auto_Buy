import 'package:flutter/material.dart';

import '../../../main.dart';
import 'command.dart';

class MonthlyCartCommand implements Command {
  @override
  final CommandArguments commandArguments;

  /// contains the parameters needed to execute run function
  /// ex. uid, productName, ...

  MonthlyCartCommand(this.commandArguments);

  @override
  Future<void> run() async {
    //await showMyDialog();
    print("monthly cart command is running");
  }

  Future<void> showMyDialog() async {
    return await showDialog(
        context: navigatorKey.currentContext,
        builder: (context) => Center(
              child: Material(
                color: Colors.red,
                child: Text('Hello'),
              ),
            ));
  }

  Future<void> _addToMonthlyCart(String productID) async {}

  Future<void> _deleteFromMonthlyCart(String productID) async {}

  @override
  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;
}
