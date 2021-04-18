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
}
