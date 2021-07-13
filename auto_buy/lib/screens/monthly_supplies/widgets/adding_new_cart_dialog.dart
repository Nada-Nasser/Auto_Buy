import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cart_supplies_screen_bloc.dart';
import '../monthly_carts_bloc.dart';

void addNewCartDialog(
  BuildContext screenContext,
  //   Future<void> Function(BuildContext context, String name) onClickDone,
  // List<String> options,
  String title,
  String content,
  MonthlyCartsBloc bloc, {
  String cartName,
  DateTime date,
  bool editCart = false,
}) {
  final _formKey = GlobalKey<FormState>();
  String name = cartName ?? "";
  DateTime selectedDate = date ??
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3);
  bool valid = true;

  bool _validateForm() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }

  String isValid(String v) {
    if (v.isNotEmpty) {
      if (valid) {
        return null;
      } else
        return "repeated cart name";
    } else {
      return "empty name";
    }
  }

  showDialog(
    context: screenContext,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: new Text(title),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      content,
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      enabled: editCart ? false : true,
                      initialValue: name,
                      decoration: InputDecoration(
                        labelText: "Cart Name",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                        hintText: "write new cart name here",
                      ),
                      onChanged: (String value) {
                        setState(() {
                          name = value;
                        });
                      },
                      validator: isValid,
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      height: 10,
                    ),
                    if (editCart)
                      ElevatedButton(
                        onPressed: () async {
                          bool isCheckedOut = await bloc.getChecekOutStat(uid: bloc.uid, cartName: cartName);
                          if(isCheckedOut)
                            await MonthlyCartsScreenBloc().cancelCheckedOutMonthlyCart(cartName,bloc.uid);
                          await bloc.deleteMonthlyCart(cartName);
                          showInSnackBar("Cart Deleted", screenContext);
                          Navigator.of(context).pop(false);
                        },
                        child: Text("Delete Cart"),
                      ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              if (!editCart)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel"),
                ),
              if (!editCart)
                TextButton(
                  onPressed: () async {
                    try {
                      await bloc.addNewMonthlyCart(name, selectedDate);
                      showInSnackBar("$name Cart Added", screenContext);
                    } on Exception catch (e) {}
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Add"),
                ),
            ],
          );
        },
      );
    },
  );
}
