import 'package:auto_buy/screens/sign_in_page/sign_in_using_email_form.dart';
import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/raised_button_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isEnable = true;

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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 25.0),
                  _header(),
                  SignInForm(
                    isEnabled: _isEnable,
                  ),
                  SizedBox(height: 35.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Or you can use",
                      style: TextStyle(color: Colors.white),
                    ),
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
    padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
        child: SocialSignInButton(
          onPressed: _isEnable ? _signInUsingGoogle : null,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          text: "Sign in with Google",
          imageAsset: "assets/images/google-logo.png",
        ),
      );

  Widget _signInWithFacebookButton() => Padding(
    padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 5.0),
        child: SocialSignInButton(
          onPressed: _isEnable ? _signInUsingFacebook : null,
          textColor: Colors.white,
          backgroundColor: Colors.blue[800],
          text: "Sign in with Facebook",
          imageAsset: "assets/images/facebook-logo.png",
        ),
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

  Future<void> _signInUsingGoogle() async {
    setState(() {
      _isEnable = false;
    });
    // TODO: Sign in using google
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final user =
      await auth.signInWithGoogle();
    setState(() {
      _isEnable = true;
    });if(user != null){
      Navigator.of(context).pop();
    }
    return null;
  }

  Future<void> _signInUsingFacebook() async {
    setState(() {
      _isEnable = false;
    });
    // TODO: sign in using facebook
    setState(() {
      _isEnable = true;
    });
  }
}
