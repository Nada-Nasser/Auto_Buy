import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'file:///D:/Documents/FCI/Y4T2/Graduation%20Project/Implementation/auto_buy/lib/services/firebase_backend/firebase_auth_service.dart';

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
