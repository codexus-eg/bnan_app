class AcademicCurriculumModel {
  const AcademicCurriculumModel({
    required this.id,
    required this.name,
    this.registrationMode,
  });

  final String id;
  final String name;
  final String? registrationMode;

  factory AcademicCurriculumModel.fromJson(Map<String, dynamic> json) {
    return AcademicCurriculumModel(
      id: _asString(json['id'] ?? json['_id']),
      name: _asString(json['name']),
      registrationMode: json['registrationMode']?.toString(),
    );
  }
}

String _asString(dynamic value) => value?.toString().trim() ?? '';
