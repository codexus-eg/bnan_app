class CertificateRecipientSnapshotModel {
  const CertificateRecipientSnapshotModel({required this.fullName});

  final String? fullName;

  factory CertificateRecipientSnapshotModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CertificateRecipientSnapshotModel(
      fullName: json['fullName']?.toString(),
    );
  }
}
