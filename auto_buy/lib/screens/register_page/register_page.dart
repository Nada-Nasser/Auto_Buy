import 'package:auto_buy/blocs/register_change_notifier.dart';
import 'package:auto_buy/screens/register_page/register_using_email_form.dart';
import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/raised_button_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isEnable = true;

  @override
  Widget build(BuildContext context) {
    print("RegisterPage SCREEN");
    //return Container();
    return ChangeNotifierProvider<RegisterChangeNotifier>(
      create: (context) => RegisterChangeNotifier(),
      child: Consumer<RegisterChangeNotifier>(
        builder: (_, notifier, __) => Scaffold(
          backgroundColor: Colors.transparent,
          body: _buildContent(notifier),
        ),
      ),
    );
  }

  Container _buildContent(RegisterChangeNotifier notifier) {
    return Container(
      decoration: gradientDecoration(),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50.0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _header(),
                RegisterForm(
                 notifier: notifier,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Or you can use",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                _signInWithGoogleButton(notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInWithGoogleButton(RegisterChangeNotifier notifier) => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
        child: SocialSignInButton(
          onPressed: _isEnable ? () => _registerUsingGoogle(notifier) : null,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          text: "Register with Google",
          imageAsset: "assets/images/google-logo.png",
        ),
      );

  Widget _signInWithFacebookButton() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 5.0),
        child: SocialSignInButton(
            onPressed: _isEnable ? _signInUsingFacebook : null,
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

  _registerUsingGoogle(RegisterChangeNotifier notifier) async {
    notifier.updateModelWith(isEnable: false);
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final user = await auth.registerWithGoogle();
    notifier.updateModelWith(isEnable: true);
    if (user != null) {
      Navigator.of(context).pop();
    }
    return null;
  }

  _signInUsingFacebook() {
    setState(() {
      _isEnable = false;
    });
    // TODO: Register using Facebook()
    setState(() {
      _isEnable = true;
    });
  }
}
