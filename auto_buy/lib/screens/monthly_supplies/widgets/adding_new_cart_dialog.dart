import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  String name = cartName ?? "";
  DateTime selectedDate = date ?? DateTime.now();
  final _formKey = GlobalKey<FormState>();
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery Date:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('${selectedDate.month} / ${selectedDate.day}'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101));
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                              });
                              if (editCart) {
                                await bloc.editCartDate(cartName, selectedDate);
                              }
                            }
                            if (editCart) {
                              showInSnackBar("Date Updated", screenContext);
                              Navigator.of(context).pop(false);
                            }
                          },
                          child: Text(
                            "Change Date",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (editCart)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await bloc.deleteMonthlyCart(cartName);
                            },
                            child: Text("Delete Cart"),
                          ),
                        ],
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
