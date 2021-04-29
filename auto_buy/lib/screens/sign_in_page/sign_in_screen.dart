import 'package:auto_buy/blocs/sign_in_changes_notifier.dart';
import 'package:auto_buy/screens/sign_in_page/sign_in_using_email_form.dart';
import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/raised_button_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("SIGN IN SCREEN");
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return ChangeNotifierProvider<SignInChangeNotifier>(
      create: (context) => SignInChangeNotifier(auth: auth),
      child: Consumer<SignInChangeNotifier>(
        builder: (_, notifier, __) => Scaffold(
          backgroundColor: Colors.transparent,
          body: _buildContent(context, notifier),
        ),
      ),
    );
  }

  Scaffold _buildContent(BuildContext context, SignInChangeNotifier notifier) {
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
                  SignInForm(),
                  SizedBox(height: 35.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Or you can use",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  _signInWithGoogleButton(context, notifier),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInWithGoogleButton(
          BuildContext context, SignInChangeNotifier notifier) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
        child: SocialSignInButton(
          onPressed: notifier.isEnable
              ? () => _signInUsingGoogle(context, notifier)
              : null,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          text: "Sign in with Google",
          imageAsset: "assets/images/google-logo.png",
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

  Future<void> _signInUsingGoogle(
      BuildContext context, SignInChangeNotifier notifier) async {
    bool flag = await notifier.enterUsingGoogle();
    if (flag) {
      Navigator.of(context).pop();
    } else {
      return null;
    }
  }
}
