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
  bool get emailVerified => user.emailVerified; // TODO email verification

  Future<User> signInWithGoogle() async {
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
    }else{
      return null;
    }
  }

  Future<User> registerWithGoogle() async{
    User userDetails = await signInWithGoogle();
    return userDetails;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await instance.signOut();
  }

  Future<User> signInWithEmail({String email, String password}) async {
    final userCredential =
    await instance.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return userCredential.user;
  }

  Future<void> checkEmailVerification() async {
    print("${user.email} : checkEmailVerification");
    user.reload();
    if (user.emailVerified) {
      print("Verified");
      if (!verificationStreamController.isClosed)
        verificationStreamController.add(true);
    }
  }

  StreamController<bool> verificationStreamController = StreamController();

  disposeVerificationStream() => verificationStreamController.close();

  Stream<bool> get verificationStream => verificationStreamController.stream;
}
