import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

enum Gender { MALE, FEMALE }

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  int _value;
  Gender _gender;
  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'ONE';
  bool secure = true;

  // Group Value for Radio Button.
  int id = 1;

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
      _createFirstNameTextField(),
      _createLastNameTextField(),
      _createEmailTextField(),
      _createPasswordTextFormField(),
      SizedBox(height: 15),
      _genderRadioButtons(),
      SizedBox(height: 15),
      _createSubmitButton(),
      // if (!canSave) CircularProgressIndicator(backgroundColor: Colors.black,),
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

  TextFormField _createLastNameTextField() {
    return TextFormField(
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: "Last Name",
        labelStyle: TextStyle(color: Colors.white),
        hintText: "write your Last Name here",
      ),
      onSaved: (email) => _email = email,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (value) =>
          value.isNotEmpty ? null : "Last name can\'t be empty",
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
      text: "Sign In",
      onPressed: () {},
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
      obscureText: secure,
      textInputAction: TextInputAction.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm(context);
  }

  _genderRadioButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Gender", style: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),),
        Row(
          children: [
            Radio(
              value: 1,
              groupValue: id,
              activeColor:Colors.red,
              onChanged: (val) {
                setState(() {
                  radioButtonItem = 'ONE';
                  _gender = Gender.MALE;
                  id = 1;
                });
              },
            ),
            Text(
              'Male',
              style: new TextStyle(fontSize: 17.0, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
              value: 2,
              groupValue: id,
              onChanged: (val) {
                setState(() {
                  radioButtonItem = 'TWO';
                  _gender = Gender.FEMALE;
                  id = 2;
                });
              },
              activeColor:Colors.red,
            ),
            Text(
              'Female',
              style: new TextStyle(fontSize: 17.0, color: Colors.white),
            ),
          ],
        ),
      ],
    );


}
