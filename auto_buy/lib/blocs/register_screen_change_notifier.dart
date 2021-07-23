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
    try {
      updateModelWith(isEnable: false);
      final user = await auth.registerWithGoogle();

      if (user == null) {
        updateModelWith(isEnable: true);
        return false;
      }

      //user.sendEmailVerification();
      //user.reload();

      Map<String, dynamic> data = {
        "name": auth.user.displayName,
        "friends": [],
        "requests": [],
        "adress": {
          "building_number": "",
          "city": "",
          "street": "",
          "governorate": "",
          "apartment_number": "",
          "floor_number": "",
        },
      "phone_number": "",
        "pic_path": auth.user.photoURL == ""
            ? "auto_buy/assets/images/optiologo.png"
            : auth.user.photoURL,
        "id": (user.displayName ?? "") + '#' + auth.uid.substring(0, 5),
      };

      await CloudFirestoreService.instance
          .setDocument(documentPath: "/users/${auth.uid}", data: data);

      updateModelWith(isEnable: true);

      if (user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      print(e);
      updateModelWith(isEnable: true);
      rethrow;
    }
  }

  Future<bool> submitForm() async {
    updateModelWith(isLoading: true);
    updateModelWith(isEnable: false);
    try {
      final user = await auth.createUserWithEmail(
        email: email,
        password: password,
      );
      if ((user == null)) {
        updateModelWith(isLoading: false);
        updateModelWith(isEnable: true);
        return false;
      }
      user.sendEmailVerification(); // TODO sendEmailVerification

      String s = auth.uid.substring(0, 5);
      print(s);
      Map<String, dynamic> data = {
        "name": name == "" ? "" : name,
        "friends": [],
        "requests": [],
        "adress": {
          "building_number": "",
          "city": "",
          "street": "",
          "governorate": "",
          "apartment_number": "",
          "floor_number": "",
        },
        "phone_number": "",
        "pic_path": auth.user.photoURL == null
            ? "/images/optiologo.png"
            : auth.user.photoURL,
        "id": name + '#' + auth.uid.substring(0, 5),
      };
      await CloudFirestoreService.instance
          .setDocument(documentPath: "/users/${auth.uid}", data: data);

      updateModelWith(isLoading: false);
      updateModelWith(isEnable: true);
      return true;
    } on FirebaseException catch (e) {
      print(e.message);
      updateModelWith(isLoading: false);
      updateModelWith(isEnable: true);
      rethrow;
    }
  }
}
