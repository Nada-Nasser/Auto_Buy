class RegisterScreenModel {
  final bool isEnable;
  final String email;
  final String password;
  final bool secure;
  final bool isLoading;

  RegisterScreenModel({
    this.isEnable = true,
    this.email = "",
    this.password = "",
    this.secure = true,
    this.isLoading = false,
  });

  RegisterScreenModel updateWith({
    bool isEnable,
    String email,
    String password,
    bool secure,
    bool isLoading,
  }) {
    return RegisterScreenModel(
      isEnable: isEnable ?? this.isEnable,
      email: email ?? this.email,
      password: password ?? this.password,
      secure: secure ?? this.secure,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
