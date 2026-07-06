class AcademicClassroomModel {
  const AcademicClassroomModel({
    required this.id,
    required this.name,
    this.gradeId,
  });

  final String id;
  final String name;
  final String? gradeId;

  factory AcademicClassroomModel.fromJson(Map<String, dynamic> json) {
    final source = json['classroom'] is Map
        ? Map<String, dynamic>.from(json['classroom'] as Map)
        : json;

    return AcademicClassroomModel(
      id: _asString(source['id'] ?? source['_id']),
      name: _asString(source['name']),
      gradeId: _gradeId(source['grade'] ?? json['grade']),
    );
  }
}

String? _gradeId(dynamic value) {
  if (value is Map) return _asNullableString(value['id'] ?? value['_id']);
  return _asNullableString(value);
}

String _asString(dynamic value) => value?.toString().trim() ?? '';

String? _asNullableString(dynamic value) {
  final text = _asString(value);
  return text.isEmpty ? null : text;
}
