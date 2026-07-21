class CertificatePeriodModel {
  const CertificatePeriodModel({required this.month, required this.year});

  final int? month;
  final int? year;

  factory CertificatePeriodModel.fromJson(Map<String, dynamic> json) {
    return CertificatePeriodModel(
      month: int.tryParse(json['month']?.toString() ?? ''),
      year: int.tryParse(json['year']?.toString() ?? ''),
    );
  }
}
