import 'package:flutter/material.dart';

class GenderRadioButtons extends StatefulWidget {
  final void Function(int val) onPressFeMale;
  final void Function(int val) onPressMale;

  const GenderRadioButtons(
      {Key key, @required this.onPressMale, @required this.onPressFeMale})
      : super(key: key);

  // Group Value for Radio Button.
  @override
  _GenderRadioButtonsState createState() => _GenderRadioButtonsState();
}

class _GenderRadioButtonsState extends State<GenderRadioButtons> {
  int id = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Gender",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Radio(
              value: 1,
              groupValue: id,
              activeColor: Colors.red,
              onChanged: (val) {
                setState(() {
                  widget.onPressMale(val);
                  id = 1;
                });
              },
            ),
            Text(
              'Male',
              style: new TextStyle(fontSize: 17.0, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
              value: 2,
              groupValue: id,
              onChanged: (val) {
                setState(() {
                  widget.onPressFeMale(val);
                  id = 2;
                });
              },
              activeColor: Colors.red,
            ),
            Text(
              'Female',
              style: new TextStyle(fontSize: 17.0, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
