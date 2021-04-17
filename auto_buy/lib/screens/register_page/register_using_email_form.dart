import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final bool isEnabled;

  const RegisterForm({Key key, this.isEnabled}) : super(key: key);

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
      if (!canSave)
        CircularProgressIndicator(
          backgroundColor: Colors.black,
        ),
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
      validator: (value) => value.isNotEmpty
          ? null
          : "First Name can\'t be empty", // TODO: Validate User Name
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
      validator: (value) => value.isNotEmpty
          ? null
          : "email can\'t be empty", // TODO: Validate Email
    );
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
      validator: (value) =>
          value.isNotEmpty ? null : "password can\'t be empty",
      //TODO: Validate Password
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
      //TODO: Submit register using email form
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
