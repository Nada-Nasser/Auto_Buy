import 'package:auto_buy/screens/home_page/homepage_wrapper.dart';
import 'package:auto_buy/screens/register_page/verification_needed_screen.dart';
import 'package:auto_buy/screens/welcome_page/welcome_screen.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseAuth =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return StreamBuilder<User>(
        stream: firebaseAuth.onAuthChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user != null) {
              print("uid:${user.uid}");
              if (firebaseAuth.emailVerified) {
                //firebaseAuth.disposeVerificationStream();
                return HomePageWrapper();
              } else {
                return StreamBuilder<bool>(
                    stream: firebaseAuth.verificationStream,
                    initialData: false,
                    builder: (context, snapshot) {
                      if (snapshot.data == false)
                        return VerificationNeeded();
                      else {
                        //     firebaseAuth.disposeVerificationStream();
                        return HomePageWrapper();
                      }
                    });
              }
            } else {
              return WelcomePage();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
