import 'dart:async';

import 'package:auto_buy/screens/optio/optio_image.dart';
import 'package:auto_buy/services/firebase_backend/google_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

class OptioChangeNotifier extends ChangeNotifier {
  List<Widget> chatWidgets = [];
  final controller = ScrollController();

  OptioChangeNotifier() {
    chatWidgets.add(optioImage());
  }

  GoogleTranslate translator = GoogleTranslate();

  ///this function is used to insert the user command and process it by the
  ///Optio api, then calls the listWidget function to add the response to the
  ///chat screen.
  void insertUserCommand({String input, int who}) async {
    String translation = await translator.translate(input);
    print("Translated Command $translation");

    // adds the user text to chat
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

    //TODO: process the user command then add optio response to the chatWidgets
    var url = Uri.parse('https://51d107406eec.ngrok.io/classifytext?text=$input');
    var response = await http.get(url);
    
    Widget OptioResponse = Container(
      width: double.infinity,
      child: Center(
        child: Text(
          response.body.toString(),
        ),
      ),
    );

    chatWidgets.add(listWidget(OptioResponse, 0));
    notifyListeners();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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

  Future<void> insertUserCommandFromVoice(String text) async {
    String translation = await translator.translate(text);
    print(translation);
    insertUserCommand(input: translation, who: 1);
  }
}
