import 'package:auto_buy/models/register_model.dart';
import 'package:auto_buy/services/string_validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RegisterChangeNotifier with ChangeNotifier, EmailAndPasswordValidator {
  final auth;
  RegisterScreenModel _model = RegisterScreenModel();

  RegisterChangeNotifier({this.auth});

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
    String name,
  }) {
    _model = _model.updateWith(
      isEnable: isEnable,
      email: email,
      password: password,
      secure: secure,
      isLoading: isLoading,
      name: name,
    );
    notifyListeners();
  }

  Future<bool> registerUsingGoogle() async {
    updateModelWith(isEnable: false);
    final user = await auth.registerWithGoogle();
    updateModelWith(isEnable: true);
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> submitForm() async {
    updateModelWith(isLoading: true);
    try {
      final user = await auth.createUserWithEmail(
        email: email,
        password: password,
      );
      user.sendEmailVerification();
      // TODO: Add user to DB
      updateModelWith(isLoading: false);
      return true;
    } on FirebaseException catch (e) {
      updateModelWith(isLoading: false);
      rethrow;
    }
  }
}
