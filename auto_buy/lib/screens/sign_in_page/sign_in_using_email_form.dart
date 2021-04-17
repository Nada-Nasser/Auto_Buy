import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  final bool isEnabled;

  const SignInForm({Key key, this.isEnabled}) : super(key: key);

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
      TextFormField(
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
        validator: (value) => value.isNotEmpty
            ? null
            : "email can\'t be empty", // TODO Validate email
      ),
      TextFormField(
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
        validator: (value) =>
            value.isNotEmpty ? null : "password can\'t be empty",
        // TODO Validate Password
        obscureText: true,
        textInputAction: TextInputAction.done,
      ),
      SizedBox(
        height: 15,
      ),
      CustomRaisedButton(
        text: "Sign In",
        onPressed: canSave ? _submit : null,
        textColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      if (!canSave)
        CircularProgressIndicator(
          backgroundColor: Colors.black,
        ),
    ];
  }

  Future<void> _submit() async {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });
      //TODO: sign in using email
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
