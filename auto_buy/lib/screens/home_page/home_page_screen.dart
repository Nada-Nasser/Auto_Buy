import 'package:auto_buy/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME PAGE"),
        actions: [FlatButton(onPressed: auth.signOut, child: Text("Logout"))],
      ),
    );
  }
}
