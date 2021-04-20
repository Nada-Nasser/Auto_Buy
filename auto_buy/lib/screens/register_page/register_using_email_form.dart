import 'package:auto_buy/blocs/register_screen_change_notifier.dart';
import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:auto_buy/widgets/exception_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _buildForm(context);
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: _buildFormFields(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(BuildContext context) {
    final notifier =
        Provider.of<RegisterChangeNotifier>(context, listen: false);
    bool canSave = notifier.canSave;
    return [
      if (!canSave) CircularProgressIndicator(backgroundColor: Colors.black),
      _createNameTextField(context),
      _createEmailTextField(context),
      _createPasswordTextFormField(context),
      SizedBox(height: 15),
      _createSubmitButton(context),
    ];
  }

  TextFormField _createNameTextField(BuildContext context) {
    final notifier =
        Provider.of<RegisterChangeNotifier>(context, listen: false);
    return TextFormField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelText: "First Name",
          labelStyle: TextStyle(color: Colors.white),
          hintText: "write your First Name here",
        ),
        onSaved: (name) => notifier.updateModelWith(name: name),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (value) => notifier.nameValidator.isValid(value)
            ? null
            : notifier.nameErrorMessage);
  }

  TextFormField _createEmailTextField(BuildContext context) {
    final notifier =
        Provider.of<RegisterChangeNotifier>(context, listen: false);
    return TextFormField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(color: Colors.white),
          hintText: "write your email here",
        ),
        onSaved: (email) => notifier.updateModelWith(email: email),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: (value) => notifier.emailValidator.isValid(value)
            ? null
            : notifier.emailErrorMessage);
  }

  CustomRaisedButton _createSubmitButton(BuildContext context) {
    final notifier =
        Provider.of<RegisterChangeNotifier>(context, listen: false);
    return CustomRaisedButton(
      text: "Register",
      onPressed: notifier.canSave ? () => _submit(context) : null,
      textColor: Colors.black,
      backgroundColor: Colors.white,
    );
  }

  TextFormField _createPasswordTextFormField(BuildContext context) {
    final notifier =
        Provider.of<RegisterChangeNotifier>(context, listen: false);
    return TextFormField(
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: "password",
        labelStyle: TextStyle(color: Colors.white),
      ),
      onSaved: (password) => notifier.updateModelWith(password: password),
      validator: (value) => notifier.passwordValidator.isValid(value)
          ? null
          : notifier.passwordErrorMessage,
      obscureText: notifier.isSecure,
      textInputAction: TextInputAction.next,
    );
  }

  Future<void> _submit(BuildContext context) async {
    final notifier =
        Provider.of<RegisterChangeNotifier>(context, listen: false);
    if (_validateForm()) {
      try {
        final flag = await notifier.submitForm();
        if (flag) Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showAlertDialog(
          context,
          titleText: "Sign in failed",
          content: e.message,
          actionButtonString: "OK",
        );
      }
    }
  }

  bool _validateForm() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }
}
