import 'package:auto_buy/blocs/register_screen_change_notifier.dart';
import 'package:auto_buy/screens/register_page/register_using_email_form.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/widgets/common_styles.dart';
import 'package:auto_buy/widgets/exception_dialog.dart';
import 'package:auto_buy/widgets/raised_button_with_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return ChangeNotifierProvider<RegisterChangeNotifier>(
      create: (context) => RegisterChangeNotifier(auth: auth),
      child: Consumer<RegisterChangeNotifier>(
        builder: (_, notifier, __) => Scaffold(
          backgroundColor: Colors.transparent,
          body: _buildContent(context, notifier),
        ),
      ),
    );
  }

  Container _buildContent(
      BuildContext context, RegisterChangeNotifier notifier) {
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
                RegisterForm(),
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
    );
  }

  Widget _signInWithGoogleButton(
          BuildContext context, RegisterChangeNotifier notifier) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
        child: SocialSignInButton(
          onPressed: notifier.isEnable
              ? () => _registerUsingGoogle(context, notifier)
              : null,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          text: "Register with Google",
          imageAsset: "assets/images/google-logo.png",
        ),
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

  _registerUsingGoogle(
      BuildContext context, RegisterChangeNotifier notifier) async {
    try {
      bool flag = await notifier.registerUsingGoogle();
      if (flag) {
        Navigator.of(context).pop();
      }
    } on FirebaseException catch (e) {
      showAlertDialog(
        context,
        titleText: "register failed",
        content: e.message,
        actionButtonString: "OK",
      );
    }
  }
}
