import 'dart:convert';

import 'package:auto_buy/screens/optio/optio_commands/monthly_cart_commands.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import 'command.dart';

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
      if (commandBody[0] == 'add') {
        print("ADD COMMAND");
        commandType = CommandType.ADD;
        if (commandBody.length == 5) {
          print("which COMMAND");
          productName = '${commandBody[3]}';
          quantity = commandBody[1].toInt() ?? 1;
          if (commandBody.last == 'shopping') {
            print("SHOPPING CART");
            commandPlace = CommandPlace.ShoppingCart;
          } else {
            commandPlace = CommandPlace.MonthlyCart;
            print("SHOPPING CART");
          }
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
          if (commandBody.last.toString().contains('cart') ||
              commandBody.last.toString().contains('shopping'))
            commandPlace = CommandPlace.ShoppingCart;
          else if (commandBody.last.toString().contains('monthly'))
            commandPlace = CommandPlace.MonthlyCart;
          else if (commandBody.last.toString().contains('friend'))
            commandPlace = CommandPlace.FriendsSystem;
          else if (commandBody.last.toString().contains('wish list'))
            commandPlace = CommandPlace.WishList;
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

    if (commandPlace == CommandPlace.MonthlyCart) {
      command = MonthlyCartCommand(commandArguments);
      print("MONTHLY");
    } else if (commandPlace == CommandPlace.ShoppingCart) {
    } else if (commandPlace == CommandPlace.ExpenseTracker) {
    } else if (commandPlace == CommandPlace.FriendsSystem) {
    } else if (commandPlace == CommandPlace.ProductsSearching) {
    } else {
      ///invalid command
    }

    return command;
  }
}
