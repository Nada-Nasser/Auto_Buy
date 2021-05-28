import 'package:auto_buy/screens/monthly_supplies/monthly_carts_screen_bloc.dart';
import 'package:auto_buy/widgets/snackbar.dart';
import 'package:flutter/material.dart';

void addNewCartDialog(
  BuildContext screenContext,
  //   Future<void> Function(BuildContext context, String name) onClickDone,
  // List<String> options,
  String title,
  String content,
  MonthlyCartsScreenBloc bloc,
) {
  String name;
  DateTime selectedDate = DateTime.now();
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101));
                            if (picked != null && picked != selectedDate)
                              setState(() {
                                selectedDate = picked;
                              });
                          },
                          child: Text(
                            "Change Date",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () async {
                  _validateForm();
                  // check if the cart exists
                  bool isExist = await bloc.checkIfMonthlyCartExist(name);
                  if (isExist) {
                    setState(() {
                      valid = false;
                    });
                  } else {
                    setState(() {
                      valid = true;
                    });
                    // add it
                    await bloc.addNewMonthlyCart(name, selectedDate);
                    showInSnackBar("Cart Added", screenContext);
                    Navigator.of(context).pop(true);
                  }
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
