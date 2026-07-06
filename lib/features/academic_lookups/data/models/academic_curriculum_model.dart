class AcademicCurriculumModel {
  const AcademicCurriculumModel({required this.id, required this.name});

  final String id;
  final String name;

  factory AcademicCurriculumModel.fromJson(Map<String, dynamic> json) {
    return AcademicCurriculumModel(
      id: _asString(json['id'] ?? json['_id']),
      name: _asString(json['name']),
    );
  }
}

String _asString(dynamic value) => value?.toString().trim() ?? '';
