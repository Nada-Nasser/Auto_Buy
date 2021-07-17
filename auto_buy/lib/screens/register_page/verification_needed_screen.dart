import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationNeeded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Check your email for verification",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We have already sent you verification email, please check it",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: auth.signOut,
                    child: Text(
                      "Back to sign in",
                      style: TextStyle(
                        //  fontSize: 15,
                        color: Colors.indigo,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.indigo,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      side: BorderSide(color: Colors.indigo, width: 2),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't get an e-mail?",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            auth.user.sendEmailVerification();
                          },
                          child: Text(
                            "Re-send",
                            style: TextStyle(
                              //  fontSize: 15,
                              color: Colors.indigo,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
