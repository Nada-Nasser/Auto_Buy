import 'package:flutter/foundation.dart';

enum CommandPlace {
  MonthlyCart,
  ShoppingCart,
  WishList,
  FriendsSystem,
  ProductsSearching,
  Invalid,
  ExpenseTracker,
}
enum CommandType { ADD, DELETE, SEARCH, OPEN, INVALID }

/// This class will be used to contain any needed parameters to execute run function in the command
/// these parameters will be extracted from api response
class CommandArguments {
  final String uid;
  final CommandType commandType;
  final CommandPlace commandPlace;
  final int quantity;
  final String productsName;
  String errorMessage;
  /// used it to add a reason why the command is invalid

  /// add any needed parameters
  /// ex. BuildContext context

  CommandArguments({
    @required this.commandType,
    @required this.commandPlace,
    this.uid,
    this.quantity,
    this.productsName,
    this.errorMessage,
  });
}

/// generic class than contain [commandArguments] to be used in [run()] function
abstract class Command {
  final CommandArguments commandArguments;

  Command(this.commandArguments);

  Future<void> run();

  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;
}
