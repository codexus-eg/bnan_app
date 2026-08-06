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
      curriculums: (json['data'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) => CurriculumModel.fromJson(Map<String, dynamic>.from(item)),
          )
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
  final String? registrationMode;

  const CurriculumModel({
    required this.id,
    required this.name,
    required this.baseCurriculum,
    required this.icon,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.registrationMode,
  });

  factory CurriculumModel.fromJson(Map<String, dynamic> json) {
    return CurriculumModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      baseCurriculum: json['baseCurriculum'] ?? '',
      icon: json['icon'] ?? '',
      description: (json['description'] ?? json['Description'] ?? '')
          .toString(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      registrationMode: _registrationMode(json['registrationMode']),
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
      registrationMode: null,
    );
  }

  static String? _registrationMode(dynamic value) {
    final mode = value?.toString().trim().toLowerCase();
    return mode == 'egyptian' || mode == 'gulf' ? mode : null;
  }
}
