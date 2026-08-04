class SubjectsPaginationModel {
  const SubjectsPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  factory SubjectsPaginationModel.fromJson(Map<String, dynamic> json) {
    return SubjectsPaginationModel(
      currentPage: _asInt(json['currentPage']),
      perPage: _asInt(json['perPage']),
      total: _asInt(json['total']),
      lastPage: _asInt(json['lastPage']),
    );
  }
}

int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;
