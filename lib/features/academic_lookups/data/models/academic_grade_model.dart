class AcademicGradeModel {
  const AcademicGradeModel({
    required this.id,
    required this.name,
    this.curriculumId,
  });

  final String id;
  final String name;
  final String? curriculumId;

  factory AcademicGradeModel.fromJson(Map<String, dynamic> json) {
    return AcademicGradeModel(
      id: _asString(json['id'] ?? json['_id']),
      name: _asString(json['name']),
      curriculumId: _asNullableString(json['curriculum']),
    );
  }
}

String _asString(dynamic value) => value?.toString().trim() ?? '';

String? _asNullableString(dynamic value) {
  final text = _asString(value);
  return text.isEmpty ? null : text;
}
