class AcademicSubjectModel {
  const AcademicSubjectModel({
    required this.id,
    required this.name,
    String? subjectId,
  }) : subjectId = subjectId ?? id;

  final String id;
  final String subjectId;
  final String name;

  factory AcademicSubjectModel.fromJson(Map<String, dynamic> json) {
    final source = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final id = _asString(source['id'] ?? source['_id']);
    return AcademicSubjectModel(
      id: id,
      subjectId: _asString(source['subjectId']).isEmpty
          ? id
          : _asString(source['subjectId']),
      name: _asString(source['name']),
    );
  }
}

String _asString(dynamic value) => value?.toString().trim() ?? '';
