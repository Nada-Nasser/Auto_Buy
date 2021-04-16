import 'package:auto_buy/screens/register_page/register_using_email_form.dart';
import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/raised_button_with_icon.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("RegisterPage SCREEN");
    //return Container();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: gradientDecoration(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _header(),
                  RegisterForm(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Or you can use",style: TextStyle(color: Colors.white),),
                  ),
                  _signInWithGoogleButton(),
                  _signInWithFacebookButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInWithGoogleButton() => Padding(
    padding: const EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 5.0),
    child: SocialSignInButton(
      onPressed: _signInUsingGoogle(),
      textColor: Colors.black,
      backgroundColor: Colors.white,
      text: "Register with Google",
      imageAsset: "assets/images/google-logo.png",
    ),
  );

  Widget _signInWithFacebookButton() => Padding(
    padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 5.0),
    child: SocialSignInButton(
        onPressed: _signInUsingFacebook(),
        textColor: Colors.white,
        backgroundColor: Colors.blue[800],
        text: "Register with Facebook",
        imageAsset: "assets/images/facebook-logo.png"),
  );

  _header() => Text(
    "Create Your Account",
    style: TextStyle(
      fontSize: 30.0,
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  );

  _signInUsingGoogle() {
    // TODO: Register using google
  }

  _signInUsingFacebook() {
    // TODO: Register using Facebook
  }
}
