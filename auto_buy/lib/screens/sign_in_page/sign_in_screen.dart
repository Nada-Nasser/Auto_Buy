import 'package:auto_buy/screens/sign_in_page/sign_in_using_email_form.dart';
import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/raised_button_with_icon.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("SIGN IN SCREEN");
    //return Container();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: gradientDecoration(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25.0),
                _header(),
                SignInForm(),
                SizedBox(height: 35.0),
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
    );
  }

  Widget _signInWithGoogleButton() => Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 5.0),
        child: SocialSignInButton(
          onPressed: _signInUsingGoogle(),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          text: "Sign in with Google",
          imageAsset: "assets/images/google-logo.png",
        ),
      );

  Widget _signInWithFacebookButton() => Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 5.0),
        child: SocialSignInButton(
            onPressed: _signInUsingFacebook(),
            textColor: Colors.white,
            backgroundColor: Colors.blue[800],
            text: "Sign in with Facebook",
            imageAsset: "assets/images/facebook-logo.png"),
      );

  _header() => Text(
        "Sign In",
        style: TextStyle(
          fontSize: 50.0,
          color: Colors.white,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
        ),
      );

  _signInUsingGoogle() {
    // TODO: Sign in using google
  }

  _signInUsingFacebook() {
    // TODO: sign in using facebook
  }
}
