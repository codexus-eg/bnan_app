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
      currentPage: int.tryParse(
        (json['currentPage'] ?? json['current_page'] ?? json['page'])
                ?.toString() ??
            '',
      ),
      lastPage: int.tryParse(
        (json['lastPage'] ??
                    json['last_page'] ??
                    json['totalPages'] ??
                    json['pages'])
                ?.toString() ??
            '',
      ),
      perPage: int.tryParse(
        (json['perPage'] ?? json['per_page'] ?? json['limit'])?.toString() ??
            '',
      ),
      total: int.tryParse(
        (json['total'] ?? json['totalCount'])?.toString() ?? '',
      ),
    );
  }
}
