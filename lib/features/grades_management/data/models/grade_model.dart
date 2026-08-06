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
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      isActive: json['isActive'] == true,
      curriculum: json['curriculum'] is! Map
          ? null
          : GradeCurriculumModel.fromJson(
              Map<String, dynamic>.from(json['curriculum']),
            ),
      subjects: (json['subjects'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) =>
                GradeSubjectModel.fromJson(Map<String, dynamic>.from(item)),
          )
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
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      icon: (json['icon'] ?? '').toString(),
    );
  }
}

class GradeSubjectModel {
  const GradeSubjectModel({required this.id, required this.name});

  final String id;
  final String name;

  factory GradeSubjectModel.fromJson(Map<String, dynamic> json) {
    return GradeSubjectModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }
}
