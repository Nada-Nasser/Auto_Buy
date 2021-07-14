import 'command.dart';

class MonthlyCartCommand implements Command {
  @override
  final CommandArguments commandArguments;

  MonthlyCartCommand(this.commandArguments);

  @override
  Future<void> run() {
    // TODO: implement run
    throw UnimplementedError();
  }

  Future<void> addToMonthlyCart() async {}

  Future<void> deleteFromMonthlyCart() async {}

  @override
  // TODO: implement isValidCommand
  bool get isValidCommand =>
      commandArguments.commandType != CommandType.INVALID;
}
