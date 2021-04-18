import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth instance = FirebaseAuth.instance;

  Stream<User> onAuthChanges() => instance.authStateChanges();

  Future<User> createUserWithEmail({String email, String password}) async {
    final userCredential = await instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  User get user => instance.currentUser;

  bool get emailVerified => true;

  //TODO: bool get emailVerified => user.emailVerified;

  Future<void> signOut() async {
    // TODO: Google sign out
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
    }
  }
}
