class StudentSubjectsResponseModel {
  const StudentSubjectsResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  final bool? success;
  final int? count;
  final List<StudentSubjectModel> data;

  factory StudentSubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentSubjectsResponseModel(
      success: json['success'] as bool?,
      count: json['count'] as int?,
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                StudentSubjectModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class StudentSubjectModel {
  const StudentSubjectModel({required this.id, required this.name});

  final String? id;
  final String? name;

  factory StudentSubjectModel.fromJson(Map<String, dynamic> json) {
    return StudentSubjectModel(
      id: _subjectId(json),
      name: json['name'] as String?,
    );
  }

  static String? _subjectId(Map<String, dynamic> json) {
    for (final key in const ['id', 'subjectId', '_id']) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value;
    }
    return null;
  }
}
