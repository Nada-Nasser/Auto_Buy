import 'package:flutter/material.dart';

Future<void> selectionDialog(
  BuildContext screenContext,
  Future<void> Function(BuildContext context, String name) onClickDone,
  List<String> options,
  String title,
  String content,
) async {
  String _chosenValue;
  return showDialog(
    context: screenContext,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: new Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(content),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: new DropdownButton<String>(
                    hint: Text('Select one option'),
                    value: _chosenValue,
                    underline: Container(),
                    items: options.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("select"),
                onPressed: () {
                  if (_chosenValue != null)
                    onClickDone(screenContext, _chosenValue);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}
