import 'package:auto_buy/models/register_model.dart';
import 'package:flutter/foundation.dart';

class RegisterChangeNotifier with ChangeNotifier {
  RegisterScreenModel model = RegisterScreenModel();

  updateModelWith({
    bool isEnable,
    String email,
    String password,
    bool secure,
    bool isLoading,
  }) {
    model = model.updateWith(
      isEnable: isEnable,
      email: email,
      password: password,
      secure: secure,
      isLoading: isLoading,
    );
    notifyListeners();
  }
}
