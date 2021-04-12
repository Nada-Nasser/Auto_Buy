import 'package:auto_buy/screens/register_page/register_page.dart';
import 'package:auto_buy/screens/sign_in_page/sign_in_screen.dart';
import 'package:auto_buy/widgets/custom_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEC9A67),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: _appIcon(),
            ),
            _button("Sign In" ,()=> _openSignInPage(context)),
            _button("Register",()=> _openRegisterPage(context)),
          ],
        ),
      ),
    );
  }

  Widget _appIcon() {
    return Image.asset(
        "assets/images/optiologo.png",
    );
  }

  Widget _button(String text , VoidCallback onClick) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
      child: CustomRaisedButton(
        text: text,
        backgroundColor: Colors.white70,
        onPressed: onClick,
      )
    );
  }

  void _openSignInPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => SignInPage(),
      ),
    );
  }

  void _openRegisterPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => RegisterScreen(),
      ),
    );
  }
}
