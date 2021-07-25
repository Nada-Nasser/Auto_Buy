import 'package:auto_buy/models/auth_model.dart';
import 'package:auto_buy/services/string_validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SignInChangeNotifier with ChangeNotifier, EmailAndPasswordValidator {
  final auth;
  AuthenticationScreenModel _model = AuthenticationScreenModel();

  SignInChangeNotifier({this.auth});

  bool get isEnable => _model.isEnable;

  bool get isLoading => _model.isLoading;

  bool get isSecure => _model.secure;

  String get email => _model.email;

  String get password => _model.password;

  String get name => _model.name;

  bool get canSave => isEnable && !isLoading;

  updateModelWith({
    bool isEnable,
    String email,
    String password,
    bool secure,
    bool isLoading,
  }) {
    _model = _model.updateWith(
      isEnable: isEnable,
      email: email,
      password: password,
      secure: secure,
      isLoading: isLoading,
    );
    notifyListeners();
  }

  Future<bool> enterUsingGoogle() async {
    try {
      updateModelWith(isEnable: false);
      final user = await auth.signInWithGoogle();
      updateModelWith(isEnable: true);
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      updateModelWith(isEnable: true);
      return false;
    }
  }

  Future<bool> submitForm() async {
    updateModelWith(isLoading: true);
    updateModelWith(isEnable: false);

    try {
      await auth.signInWithEmail(
        email: email,
        password: password,
      );

      updateModelWith(isLoading: false);
      updateModelWith(isEnable: true);
      return true;
    } on FirebaseException {
      updateModelWith(isLoading: false);
      updateModelWith(isEnable: true);
      return false;
    }
  }
}
