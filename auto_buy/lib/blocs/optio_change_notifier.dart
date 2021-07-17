
import 'package:auto_buy/screens/optio/optio_commands/command.dart';
import 'package:auto_buy/screens/optio/optio_commands/command_generator.dart';
import 'package:auto_buy/screens/optio/optio_image.dart';
import 'package:auto_buy/services/firebase_backend/google_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

class OptioChangeNotifier extends ChangeNotifier {
  List<Widget> chatWidgets = [];
  final controller = ScrollController();
  final CommandGenerator _commandGenerator = CommandGenerator();
  final String uid;

  OptioChangeNotifier(this.uid) {
    chatWidgets.add(optioImage());
  }

  GoogleTranslate translator = GoogleTranslate();

  ///this function is used to insert the user command and process it by the
  ///Optio api, then calls the listWidget function to add the response to the
  ///chat screen.
  void insertUserCommand({String input, int who}) async {
    Widget optioResponse;
    String translation = await translator.translate(input); // english text
    print("Translated Command $translation");

    chatWidgets.add(listWidget(
        Text(
          input,
          style: TextStyle(),
        ),
        who));

    notifyListeners();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    var url = Uri.parse('https://f5c7eafc5baa.ngrok.io/classifytext/$translation');
    var response = await http.get(url);
    print(response.body.toString());
    print(translation);

    Command command = _commandGenerator.generateCommand(response, uid);

    /// generate command that contain the needed arguments to execute it
    if (command.isValidCommand) {
      try {
        /**
         * 1- (if the command was add/delete something from cart)
         *    in run function:-
         *    1- open dialog that contain list of products found from search
         *    2- user just need to select on of the displayed products
         *    3- if quantity = "", then quantity = 1
         *    4- if cart type not mentioned => cart_type = shopping cart (Default value)
         *    3- perform the add/delete process
         *    response widget:
         *    only text message = "Success Message" or "failure message"
         * 2- if search/ Open
         *     in run function:-
         *     1- push new screen with the products/users found
         *     response widget: no response widget
         * 3- if invalid command:
         *    response widget:
         *    only text message = "failure message"
         * */

        await command.run();

        String successMessage = "Command executed successfully"; //TODO
        optioResponse = _createOptioResponse(successMessage, true);

        print("Command executed successfully");
      } on Exception catch (e) {
        String errorMessage = response.body.toString(); //TODO
        optioResponse = _createOptioResponse("Something went wrong", false);

        print(e);
      }
    } else {
      String errorMessage = response.body.toString(); //TODO
      optioResponse = _createOptioResponse("Command Failed", false);
      print("Command Failed");
    }

    chatWidgets.add(
        listWidget(_createOptioResponse(response.body.toString(), false), 0));
    chatWidgets.add(listWidget(optioResponse, 0));

    notifyListeners();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Container _createOptioResponse(String response, bool isSuccessfulResponse) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Text(
          response,
        ),
      ),
    );
  }

  ///this function builds a widget that is inserted into the chat screen, its
  ///look depends on the who parameter.
  Widget listWidget(Widget input, int who) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: Row(
        mainAxisAlignment:
            who == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (who != 1)
            Container(
              child: Image.asset("assets/images/optioface.png", width: 50),
            ),
          if (who != 1) SizedBox(width: 10),
          Flexible(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.all(20),
                  child: input,
                  decoration: BoxDecoration(
                    color: who == 1 ? Colors.lightGreenAccent : Colors.orange,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ],
            ),
          ),
          if (who == 1) SizedBox(width: 10),
          if (who == 1) Icon(Icons.person),
        ],
      ),
    );
  }
}
