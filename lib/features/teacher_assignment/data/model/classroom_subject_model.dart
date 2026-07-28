class ClassroomSubjectModel {
  final String id;
  final String classroom;
  final List<String> subjects;

  const ClassroomSubjectModel({
    required this.id,
    required this.classroom,
    required this.subjects,
  });

  factory ClassroomSubjectModel.fromJson(Map<String, dynamic> json) {
    return ClassroomSubjectModel(
      id: _asString(json['id'] ?? json['_id']),
      classroom: _entityId(json['classroom']),
      subjects: _subjectIds(json),
    );
  }
}

List<String> _subjectIds(Map<String, dynamic> json) {
  final values = <dynamic>[
    if (json['subject'] != null) json['subject'],
    if (json['subjects'] is List) ...(json['subjects'] as List),
  ];
  return values.map(_entityId).where((id) => id.isNotEmpty).toSet().toList();
}

String _entityId(dynamic value) {
  if (value is Map) return _asString(value['id'] ?? value['_id']);
  return _asString(value);
}

String _asString(dynamic value) => value?.toString().trim() ?? '';
