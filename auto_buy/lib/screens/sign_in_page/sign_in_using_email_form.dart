import 'package:auto_buy/blocs/sign_in_changes_notifier.dart';
import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:auto_buy/widgets/exception_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _buildForm(context);
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: _buildFormFields(context),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(BuildContext context) {
    final notifier = Provider.of<SignInChangeNotifier>(context, listen: false);
    bool canSave = notifier.canSave;
    return [
      _createEmailTextFormField(context),
      _createPasswordTextFormField(context),
      SizedBox(height: 15),
      createSubmitButton(context, canSave),
      if (!canSave) CircularProgressIndicator(backgroundColor: Colors.black)
    ];
  }

  CustomRaisedButton createSubmitButton(BuildContext context, bool canSave) {
    final notifier = Provider.of<SignInChangeNotifier>(context, listen: false);

    return CustomRaisedButton(
      text: "Sign In",
      onPressed: notifier.canSave ? () => _submit(context) : null,
      textColor: Colors.black,
      backgroundColor: Colors.white,
    );
  }

  TextFormField _createEmailTextFormField(
    BuildContext context,
  ) {
    final notifier = Provider.of<SignInChangeNotifier>(context, listen: false);

    return TextFormField(
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
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
          : notifier.emailErrorMessage,
    );
  }

  TextFormField _createPasswordTextFormField(
    BuildContext context,
  ) {
    final notifier = Provider.of<SignInChangeNotifier>(context, listen: false);

    return TextFormField(
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: "password",
        labelStyle: TextStyle(color: Colors.white),
      ),
      onSaved: (password) => notifier.updateModelWith(password: password),
      validator: (value) => notifier.passwordValidator.isValid(value)
          ? null
          : notifier.passwordErrorMessage,
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  Future<void> _submit(BuildContext context) async {
    final notifier = Provider.of<SignInChangeNotifier>(context, listen: false);
    if (_validateForm()) {
      try {
        final flag = await notifier.submitForm();
        if (flag)
          Navigator.of(context).pop();
        else
          showAlertDialog(context,
              titleText: "Sign in Failed",
              content: "make sure you write a right email and password",
              actionButtonString: "Ok");
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
