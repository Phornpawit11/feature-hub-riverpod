class UpdateProfileRequest {
  const UpdateProfileRequest({required this.displayName});

  final String displayName;

  Map<String, dynamic> toJson() {
    return {'displayName': displayName};
  }
}
