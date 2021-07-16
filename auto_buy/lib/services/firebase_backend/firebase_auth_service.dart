import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  FirebaseAuth instance = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User> onAuthChanges() => instance.authStateChanges();

  Future<User> createUserWithEmail({String email, String password}) async {
    final userCredential = await instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  User get user => instance.currentUser;

  String get uid => instance.currentUser.uid;

  //bool get emailVerified => true;

  bool get emailVerified => user.emailVerified;

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential result = await instance.signInWithCredential(credential);
        User userDetails = result.user;
        return userDetails;
      } else {
        return null;
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<User> registerWithGoogle() async {
    try {
      User userDetails = await signInWithGoogle();
      return userDetails;
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await instance.signOut();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<User> signInWithEmail({String email, String password}) async {
    try {
      final userCredential =
          await instance.signInWithCredential(EmailAuthProvider.credential(
        email: email,
        password: password,
      ));
      return userCredential.user;
    } on Exception catch (e) {
      throw e;
    }
  }
}
