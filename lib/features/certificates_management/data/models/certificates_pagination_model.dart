class CertificatesPaginationModel {
  const CertificatesPaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  factory CertificatesPaginationModel.fromJson(Map<String, dynamic> json) {
    return CertificatesPaginationModel(
      currentPage: int.tryParse(json['current_page']?.toString() ?? ''),
      lastPage: int.tryParse(json['last_page']?.toString() ?? ''),
      perPage: int.tryParse(json['per_page']?.toString() ?? ''),
      total: int.tryParse(json['total']?.toString() ?? ''),
    );
  }
}
