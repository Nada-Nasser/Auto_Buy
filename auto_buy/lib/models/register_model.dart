class RegisterScreenModel {
  final bool isEnable;
  final String email;
  final String password;
  final bool secure;
  final bool isLoading;
  final String name;

  RegisterScreenModel({
    this.name,
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
    String name,
  }) {
    return RegisterScreenModel(
      isEnable: isEnable ?? this.isEnable,
      email: email ?? this.email,
      password: password ?? this.password,
      secure: secure ?? this.secure,
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
    );
  }
}
