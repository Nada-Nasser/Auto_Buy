import 'package:auto_buy/models/auth_model.dart';
import 'package:auto_buy/services/firebase_backend/firebase_auth_service.dart';
import 'package:auto_buy/services/firebase_backend/firestore_service.dart';
import 'package:auto_buy/services/string_validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RegisterChangeNotifier with ChangeNotifier, EmailAndPasswordValidator {
  final FirebaseAuthService auth;
  AuthenticationScreenModel _model = AuthenticationScreenModel();

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
    Map <String, dynamic> data = {
      "name" : auth.user.displayName == "" ? "" : auth.user.displayName,
      "friends" : {},
      "adress" : {"building_number" : "", "city" : "", "street" : ""},
      "pic_path" : auth.user.photoURL == "" ? "auto_buy/assets/images/optiologo.png" : auth.user.photoURL,
    };
    try {
      await CloudFirestoreService.instance.setDocument(documentPath: "/users/${auth.uid}", data: data);
    } catch (e){
      print(e);
    }
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
      print(name);
      Map <String, dynamic> data = {
        "name" : name == "" ? "" : name,
        "friends" : {},
        "adress" : {"building_number" : "", "city" : "", "street" : ""},
        "pic_path" : auth.user.photoURL == "" ? "auto_buy/assets/images/optiologo.png" : auth.user.photoURL,
      };
      await CloudFirestoreService.instance.setDocument(documentPath: "/users/${auth.uid}", data: data);

      updateModelWith(isLoading: false);
      return true;
    } on FirebaseException catch (e) {
      updateModelWith(isLoading: false);
      rethrow;
    }
  }
}
