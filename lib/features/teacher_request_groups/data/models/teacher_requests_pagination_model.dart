class TeacherRequestsPaginationModel {
  const TeacherRequestsPaginationModel({
    this.currentPage = 0,
    this.perPage = 20,
    this.total = 0,
    this.lastPage = 0,
  });

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  bool get hasNextPage => currentPage < lastPage;

  factory TeacherRequestsPaginationModel.fromJson(Object? value) {
    final json = value is Map ? value : const {};
    int number(String key, int fallback) =>
        int.tryParse(json[key]?.toString() ?? '') ?? fallback;
    return TeacherRequestsPaginationModel(
      currentPage: number('currentPage', 0),
      perPage: number('perPage', 20),
      total: number('total', 0),
      lastPage: number('lastPage', 0),
    );
  }
}
