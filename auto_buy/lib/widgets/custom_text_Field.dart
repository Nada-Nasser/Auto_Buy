import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
    @required this.labelText,
    this.hintText,
    this.autocorrect = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.controller,
    this.isEnabled = true,
    this.errorText,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
  }) : super(key: key);

  final String labelText;
  final String hintText;
  final bool autocorrect;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final bool isEnabled;
  final String errorText;
  final FocusNode focusNode;
  final void Function() onEditingComplete;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.white
        ),
        hintText: hintText,
        enabled: isEnabled,
        errorText: errorText,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: focusNode,
      onEditingComplete: () => onEditingComplete,
      onChanged: onChanged,
    );
  }
}
