import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:auto_buy/services/string_validation.dart';
import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:auto_buy/widgets/exception_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget with EmailAndPasswordValidator {
  RegisterForm({Key key, this.isEnabled}) : super(key: key);

  final bool isEnabled;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  int _value;
  bool _secure = true;
  bool _isLoading = false;

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
    bool canSave = widget.isEnabled && !_isLoading;
    return [
      if (!canSave) CircularProgressIndicator(backgroundColor: Colors.black),
      _createNameTextField(),
      _createEmailTextField(),
      _createPasswordTextFormField(),
      SizedBox(height: 15),
      _createSubmitButton(),
    ];
  }

  TextFormField _createNameTextField() {
    return TextFormField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelText: "First Name",
          labelStyle: TextStyle(color: Colors.white),
          hintText: "write your First Name here",
        ),
        onSaved: (email) => _email = email,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (value) => widget.nameValidator.isValid(value)
            ? null
            : widget.nameErrorMessage);
  }

  TextFormField _createEmailTextField() {
    return TextFormField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(color: Colors.white),
          hintText: "write your email here",
        ),
        onSaved: (email) => _email = email,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: (value) => widget.emailValidator.isValid(value)
            ? null
            : widget.emailErrorMessage);
  }

  CustomRaisedButton _createSubmitButton() {
    bool canSave = widget.isEnabled && !_isLoading;
    return CustomRaisedButton(
      text: "Register",
      onPressed: canSave ? _submit : null,
      textColor: Colors.black,
      backgroundColor: Colors.white,
    );
  }

  TextFormField _createPasswordTextFormField() {
    return TextFormField(
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: "password",
        labelStyle: TextStyle(color: Colors.white),
      ),
      onSaved: (password) => _password = password,
      validator: (value) => widget.passwordValidator.isValid(value)
          ? null
          : widget.passwordErrorMessage,
      obscureText: _secure,
      textInputAction: TextInputAction.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm(context);
  }

  Future<void> _submit() async {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final auth = Provider.of<FirebaseAuthService>(context, listen: false);
        final user = await auth.createUserWithEmail(
          email: _email,
          password: _password,
        );
        print("uid:${user.uid}");
        // TODO: Add user to DB
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showAlertDialog(
          context,
          titleText: "Sign in failed",
          content: e.message,
          actionButtonString: "OK",
        );
      }

      setState(() {
        _isLoading = false;
      });
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
