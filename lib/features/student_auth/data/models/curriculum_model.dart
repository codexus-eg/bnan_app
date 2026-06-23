class CurriculumsResponseModel {
  final bool success;
  final List<CurriculumModel> curriculums;

  const CurriculumsResponseModel({
    required this.success,
    required this.curriculums,
  });

  factory CurriculumsResponseModel.fromJson(Map<String, dynamic> json) {
    return CurriculumsResponseModel(
      success: json['success'] ?? false,
      curriculums: (json['data'] as List<dynamic>? ?? [])
          .map((item) => CurriculumModel.fromJson(item))
          .toList(),
    );
  }
}

class CurriculumModel {
  final String id;
  final String name;
  final String baseCurriculum;
  final String icon;
  final String description;
  final String createdAt;
  final String updatedAt;

  const CurriculumModel({
    required this.id,
    required this.name,
    required this.baseCurriculum,
    required this.icon,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CurriculumModel.fromJson(Map<String, dynamic> json) {
    return CurriculumModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      baseCurriculum: json['baseCurriculum'] ?? '',
      icon: json['icon'] ?? '',
      description: json['Description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
 factory CurriculumModel.mock(Map<String, dynamic> json) {
  return const CurriculumModel(
    id: '',
    name: 'Curriculum Name',
    baseCurriculum: '',
    icon: '',
    description: '',
    createdAt: '',
    updatedAt: '',
  );
}
}