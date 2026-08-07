class StudentSubjectModel {
  const StudentSubjectModel({required this.id, required this.name});

  final String id;
  final String name;

  factory StudentSubjectModel.fromJson(Object? json) {
    final map = json is Map ? Map<String, dynamic>.from(json) : const {};
    return StudentSubjectModel(
      id: (map['id'] ?? map['_id'] ?? '').toString().trim(),
      name: (map['name'] ?? '').toString().trim(),
    );
  }

  static List<StudentSubjectModel> listFromResponse(Object? response) {
    final data = response is Map ? response['data'] : response;
    if (data is! List) return const [];
    return data
        .map(StudentSubjectModel.fromJson)
        .toList(growable: false);
  }
}
