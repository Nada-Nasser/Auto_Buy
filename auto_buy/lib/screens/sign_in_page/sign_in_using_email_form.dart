import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:auto_buy/services/string_validation.dart';
import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:auto_buy/widgets/exception_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget with EmailAndPasswordValidator {
  final bool isEnabled;

  SignInForm({Key key, this.isEnabled}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    print("NEW FORM");
    print(widget.isEnabled);
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
    bool canSave = widget.isEnabled && !_isLoading;
    return [
      _createEmailTextFormField(),
      _createPasswordTextFormField(),
      SizedBox(height: 15),
      createSubmitButton(canSave),
      if (!canSave) CircularProgressIndicator(backgroundColor: Colors.black)
    ];
  }

  CustomRaisedButton createSubmitButton(bool canSave) {
    return CustomRaisedButton(
      text: "Sign In",
      onPressed: canSave ? _submit : null,
      textColor: Colors.black,
      backgroundColor: Colors.white,
    );
  }

  TextFormField _createEmailTextFormField() {
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
      onSaved: (email) => _email = email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) => widget.emailValidator.isValid(value)
          ? null
          : widget.emailErrorMessage,
    );
  }

  TextFormField _createPasswordTextFormField() {
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
      onSaved: (password) => _password = password,
      validator: (value) => widget.passwordValidator.isValid(value)
          ? null
          : widget.passwordErrorMessage,
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  Future<void> _submit() async {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final auth = Provider.of<FirebaseAuthService>(context, listen: false);
        final user =
            await auth.signInWithEmail(email: _email, password: _password);
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
