import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{
  FirebaseAuth instance = FirebaseAuth.instance;

  Stream<User> onAuthChanges() => instance.authStateChanges();
}