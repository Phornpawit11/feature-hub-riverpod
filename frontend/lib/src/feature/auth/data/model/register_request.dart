class RegisterRequest {
  const RegisterRequest({
    required this.displayName,
    required this.email,
    required this.password,
  });

  final String displayName;
  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return {'displayName': displayName, 'email': email, 'password': password};
  }
}
