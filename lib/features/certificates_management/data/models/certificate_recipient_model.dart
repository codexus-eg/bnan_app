class CertificateRecipientModel {
  const CertificateRecipientModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  final String? id;
  final String? fullName;
  final String? email;
  final String? role;

  factory CertificateRecipientModel.fromJson(Map<String, dynamic> json) {
    return CertificateRecipientModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      role: json['role']?.toString(),
    );
  }
}
