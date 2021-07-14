import 'package:flutter/foundation.dart';

enum CartType { MonthlyCart, ShoppingCart, WishList }
enum CommandType { ADD, DELETE, SEARCH, OPEN, INVALID }

class CommandArguments {
  final String uid;
  final CommandType commandType;
  final CartType cartType;
  final int quantity;
  final String productsName;

  CommandArguments({
    @required this.commandType,
    this.uid,
    this.cartType,
    this.quantity,
    this.productsName,
  });
// add any needed arguments
}

abstract class Command {
  final CommandArguments commandArguments;

  Command(this.commandArguments);

  Future<void> run();

  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;
}
