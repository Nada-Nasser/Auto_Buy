import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends CustomRaisedButton {
  final String imageAsset;

  SocialSignInButton({
    onPressed,
    @required text,
    backgroundColor,
    textColor,
    @required this.imageAsset,
  })  : assert(imageAsset != null),
        super(
        onPressed: onPressed,
        text: text,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: onPressed,
      disabledColor: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(imageAsset),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 15.0),
            ),
            Opacity(
              opacity: 0,
              child: Image.asset(imageAsset),
            ),
          ],
        ),
      ),
      color: backgroundColor,
    );
  }
}
