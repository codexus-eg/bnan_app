class CertificateUserModel {
  const CertificateUserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  final String? id;
  final String? fullName;
  final String? email;

  factory CertificateUserModel.fromJson(Map<String, dynamic> json) {
    return CertificateUserModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
    );
  }
}
