import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;

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
        validator: (value) => value.isNotEmpty ? null : "email can\'t be empty",
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
        validator: (value) => value.isNotEmpty ? null : "email can\'t be empty",
        obscureText: true,
        textInputAction: TextInputAction.done,
      ),
      SizedBox(height: 15,),
      CustomRaisedButton(
        text: "Sign In",
        onPressed: () {},
        textColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      // if (!canSave) CircularProgressIndicator(backgroundColor: Colors.black,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm(context);
  }
}
