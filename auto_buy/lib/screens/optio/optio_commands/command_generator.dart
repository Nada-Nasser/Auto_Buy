import 'dart:convert';

import 'package:auto_buy/screens/optio/optio_commands/expense_tracker_commands.dart';
import 'package:auto_buy/screens/optio/optio_commands/monthly_cart_commands.dart';
import 'package:auto_buy/screens/optio/optio_commands/search_commands.dart';
import 'package:auto_buy/screens/optio/optio_commands/shopping_cart_commands.dart';
import 'package:auto_buy/services/product_search_services.dart';
import 'package:auto_buy/widgets/exception_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import 'command.dart';
import 'friend_command.dart';

class CommandGenerator {
  /// using [response] parameter from optio api
  /// 1- create [CommandArguments] object from the response fields
  /// 2- create and return [Command] object (its type based on the response fields )
  /// the [Command] object could be MonthlyCartCommand, ShoppingCartCommand, FriendsCommand,...
  Command generateCommand(http.Response response, String uid) {
    List<dynamic> commandBody = json.decode(response.body);
    CommandType commandType;
    CommandPlace commandPlace;
    String productName;
    int quantity;
    Command command;
    BuildContext context = navigatorKey.currentContext;

    try {
      if (commandBody != null) {
        if (commandBody[0] == 'add') {
          commandType = CommandType.ADD;
          if (commandBody.length == 5) {
            productName = '${commandBody[3]}';
            quantity = commandBody[1] == "" ? 1 : commandBody[1].toInt();
            if (commandBody.last == 'shopping')
              commandPlace = CommandPlace.ShoppingCart;
            else
              commandPlace = CommandPlace.MonthlyCart;
          } else {
            commandPlace = CommandPlace.FriendsSystem;
          }
        } else if (commandBody[0] == 'delete') {
          commandType = CommandType.DELETE;
          if (commandBody.length == 3) {
            productName = commandBody[1];
            if (commandBody.last == 'shopping')
              commandPlace = CommandPlace.ShoppingCart;
            else
              commandPlace = CommandPlace.MonthlyCart;
          } else {
            commandPlace = CommandPlace.FriendsSystem;
          }
        } else if (commandBody[0] == 'open') {
          commandType = CommandType.OPEN;
          if (commandBody.length == 2) {
            if (commandBody.last.toString().contains('monthly'))
              commandPlace = CommandPlace.MonthlyCart;
            else if (commandBody.last.toString().contains('wish list'))
              commandPlace = CommandPlace.WishList;
            else if (commandBody.last.toString().contains('cart') ||
                commandBody.last.toString().contains('shopping'))
              commandPlace = CommandPlace.ShoppingCart;
            else if (commandBody.last.toString().contains('friend'))
              commandPlace = CommandPlace.FriendsSystem;
            else if (commandBody.last.toString().contains('expense') ||
                commandBody.last.toString().contains('tracker'))
              commandPlace = CommandPlace.ExpenseTracker;
            else {
              commandPlace = CommandPlace.Invalid;
              commandType = CommandType.INVALID;
            }
          } else {
            commandType = CommandType.INVALID;
            commandPlace = CommandPlace.Invalid;
          }
        } else if (commandBody[0] == 'search') {
          commandType = CommandType.SEARCH;
          if (commandBody.length == 2) {
            commandPlace = CommandPlace.ProductsSearching;
            productName = commandBody[1];
          } else {
            commandType = CommandType.INVALID;
            commandPlace = CommandPlace.Invalid;
          }
        } else {
          commandType = CommandType.INVALID;
          commandPlace = CommandPlace.Invalid;
        }
      } else {
        commandType = CommandType.INVALID;
        commandPlace = CommandPlace.Invalid;
      }
    } on Exception catch (e) {
      print(e);
      commandType = CommandType.INVALID;
      commandPlace = CommandPlace.Invalid;
    }

    CommandArguments commandArguments = CommandArguments(
        commandType: commandType,
        commandPlace: commandPlace,
        productsName: productName,
        quantity: quantity,
        uid: uid,
        context: context);
    print('command arguments');

    if (commandPlace == CommandPlace.MonthlyCart) {
      command = MonthlyCartCommand(commandArguments);
    } else if (commandPlace == CommandPlace.ShoppingCart) {
      command = ShoppingCartCommand(commandArguments);
    } else if (commandPlace == CommandPlace.ExpenseTracker) {
      command = ExpenseTrackerCommand(commandArguments);
    } else if (commandPlace == CommandPlace.FriendsSystem) {
      command = FriendCommand(commandArguments);
    } else if (commandPlace == CommandPlace.ProductsSearching) {
      command = SearchCommand(commandArguments);
    } else {
      command = InvalidCommand(commandArguments);
    }
    return command;
  }
}

class InvalidCommand implements Command {
  @override
  final CommandArguments commandArguments;

  InvalidCommand(this.commandArguments);

  @override
  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;

  @override
  Future<void> run(ProductSearchServices searchService) async {
    await showAlertDialog(
      commandArguments.context,
      titleText: "Error",
      content: "Something went wrong",
      actionButtonString: "OK",
    );
  }
}
