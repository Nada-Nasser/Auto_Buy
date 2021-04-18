import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showAlertDialog(
  BuildContext context, {
  @required String titleText,
  @required String content,
  cancelActionString,
  @required String actionButtonString,
}) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(titleText),
            content: Text(content),
            actions: [
              if (cancelActionString != null)
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelActionString),
                ),
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(actionButtonString),
              ),
            ],
          );
        });
  } else {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(titleText),
            content: Text(content),
            actions: [
              if (cancelActionString != null)
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelActionString),
                ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(actionButtonString),
              ),
            ],
          );
        });
  }
}
