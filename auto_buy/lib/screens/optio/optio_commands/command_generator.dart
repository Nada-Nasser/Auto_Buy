import 'package:http/http.dart' as http;

import 'command.dart';

class CommandGenerator {
  /// using [response] parameter from optio api
  /// 1- create [CommandArguments] object from the response fields
  /// 2- create and return [Command] object (its type based on the response fields )
  /// the [Command] object could be MonthlyCartCommand, ShoppingCartCommand, FriendsCommand,...
  Command generateCommand(http.Response response) {
    // TODO: implement generateCommand using json response create Command object
  }
}
