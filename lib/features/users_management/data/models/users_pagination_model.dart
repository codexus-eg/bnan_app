class UsersPaginationModel {
  const UsersPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  factory UsersPaginationModel.fromJson(Map<String, dynamic> json) {
    return UsersPaginationModel(
      currentPage: _asInt(json['currentPage']),
      perPage: _asInt(json['perPage']),
      total: _asInt(json['total']),
      lastPage: _asInt(json['lastPage']),
    );
  }

  factory UsersPaginationModel.empty() {
    return const UsersPaginationModel(
      currentPage: 0,
      perPage: 0,
      total: 0,
      lastPage: 0,
    );
  }
}

int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;
