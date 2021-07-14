import 'command.dart';

class MonthlyCartCommand implements Command {
  @override
  final CommandArguments commandArguments;

  /// contains the parameters needed to execute run function
  /// ex. uid, productName, ...

  MonthlyCartCommand(this.commandArguments);

  @override
  Future<void> run() {
    // TODO: implement run
    throw UnimplementedError();
  }

  Future<void> _addToMonthlyCart(String productID) async {}

  Future<void> _deleteFromMonthlyCart(String productID) async {}

  @override
  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;
}
