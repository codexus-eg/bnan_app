class GradeModel {
  const GradeModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.subjects,
    this.curriculum,
  });

  final String id;
  final String name;
  final bool isActive;
  final GradeCurriculumModel? curriculum;
  final List<GradeSubjectModel> subjects;

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
      curriculum: json['curriculum'] == null
          ? null
          : GradeCurriculumModel.fromJson(json['curriculum']),
      subjects: (json['subjects'] as List? ?? [])
          .map((item) => GradeSubjectModel.fromJson(item))
          .toList(),
    );
  }
}

class GradeCurriculumModel {
  const GradeCurriculumModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final String icon;

  factory GradeCurriculumModel.fromJson(Map<String, dynamic> json) {
    return GradeCurriculumModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class GradeSubjectModel {
  const GradeSubjectModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory GradeSubjectModel.fromJson(Map<String, dynamic> json) {
    return GradeSubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}