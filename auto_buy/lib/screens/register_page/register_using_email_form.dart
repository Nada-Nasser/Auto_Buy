import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  int _value;
  bool _secure = true;

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
    return [
      // if (!canSave) CircularProgressIndicator(backgroundColor: Colors.black,),
      _createFirstNameTextField(),
      _createEmailTextField(),
      _createPasswordTextFormField(),
      SizedBox(height: 15),
      _createSubmitButton(),
    ];
  }

  TextFormField _createFirstNameTextField() {
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
      validator: (value) =>
      value.isNotEmpty ? null : "First Name can\'t be empty",
    );
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
      validator: (value) => value.isNotEmpty ? null : "email can\'t be empty",
    );
  }

  CustomRaisedButton _createSubmitButton() {
    return CustomRaisedButton(
      text: "Register",
      onPressed: _submit,
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
      validator: (value) => value.isNotEmpty ? null : "email can\'t be empty",
      obscureText: _secure,
      textInputAction: TextInputAction.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm(context);
  }

  Future<void> _submit() async {
    //TODO: Submit register using email form
  }
}
