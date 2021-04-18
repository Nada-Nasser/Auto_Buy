import 'dart:async';

import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationNeeded extends StatefulWidget {
  @override
  _VerificationNeededState createState() => _VerificationNeededState();
}

class _VerificationNeededState extends State<VerificationNeeded> {
  Timer timer;

  @override
  void initState() {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await auth.checkEmailVerification();
      /*if(auth.user.emailVerified){
        Navigator.of(context).pop();
      }*/
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Auto Buy"),
        actions: [
          FlatButton.icon(
              onPressed: auth.signOut,
              label: Text("Go Back"),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
        child: Text("You need to verify your email"),
      ),
    );
  }
}
