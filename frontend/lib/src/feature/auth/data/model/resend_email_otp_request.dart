class ResendEmailOtpRequest {
  const ResendEmailOtpRequest({required this.verificationId});

  final String verificationId;

  Map<String, dynamic> toJson() {
    return {'verificationId': verificationId};
  }
}
