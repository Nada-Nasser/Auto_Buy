import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  CustomRaisedButton({
    this.onPressed,
    @required this.text,
    this.backgroundColor, this.textColor = Colors.black45,
  }):assert(text != null);

  Widget build(BuildContext context){
    return  RaisedButton(
      color: backgroundColor,
      disabledColor: backgroundColor,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(text,style: TextStyle(color: textColor,fontSize: 15.0),),
      ),
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
