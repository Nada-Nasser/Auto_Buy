abstract class StringValidator {
  bool isValid(String string);
}

class EmailValidator implements StringValidator {
  @override
  bool isValid(String string) => string.isNotEmpty;
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String string) => string.isNotEmpty;
}

class PasswordValidator implements StringValidator {
  @override
  bool isValid(String string) => string.isNotEmpty && (string.length >= 8);
}

mixin EmailAndPasswordValidator {
  final StringValidator emailValidator = EmailValidator();
  final StringValidator passwordValidator = PasswordValidator();
  final StringValidator nameValidator = NonEmptyStringValidator();
  final String emailErrorMessage = "Email can\'t be empty";
  final String nameErrorMessage = "Name can\'t be empty";
  final String passwordErrorMessage =
      "password can\'t be less than 8 characters";
}
