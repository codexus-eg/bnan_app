class SubjectsResponseModel {
  const SubjectsResponseModel({
    required this.success,
    required this.length,
    required this.data,
  });

  final bool success;
  final int length;
  final List<SubjectModel> data;

  factory SubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    return SubjectsResponseModel(
      success: json['success'] ?? false,
      length: json['length'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => SubjectModel.fromJson(item))
          .toList(),
    );
  }
}

class SubjectModel {
  const SubjectModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.curriculum,
    this.grade,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final bool isActive;
  final SubjectCurriculumModel? curriculum;
  final SubjectGradeModel? grade;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    final grade = _subjectGrade(json);
    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
      curriculum: json['curriculum'] == null
          ? null
          : SubjectCurriculumModel.fromJson(json['curriculum']),
      grade: grade == null ? null : SubjectGradeModel.fromJson(grade),
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }
}

Map<String, dynamic>? _subjectGrade(Map<String, dynamic> json) {
  final grade = json['grade'];
  if (grade is Map) return Map<String, dynamic>.from(grade);
  final grades = json['grades'];
  if (grades is! List) return null;
  for (final item in grades) {
    if (item is Map) return Map<String, dynamic>.from(item);
  }
  return null;
}

class SubjectCurriculumModel {
  const SubjectCurriculumModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final String icon;

  factory SubjectCurriculumModel.fromJson(Map<String, dynamic> json) {
    return SubjectCurriculumModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class SubjectGradeModel {
  const SubjectGradeModel({this.id, this.name});

  final String? id;
  final String? name;

  factory SubjectGradeModel.fromJson(Map<String, dynamic> json) {
    return SubjectGradeModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
    );
  }
}
