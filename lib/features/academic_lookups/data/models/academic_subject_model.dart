class AcademicSubjectModel {
  const AcademicSubjectModel({required this.id, required this.name});

  final String id;
  final String name;

  factory AcademicSubjectModel.fromJson(Map<String, dynamic> json) {
    final source = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    return AcademicSubjectModel(
      id: _asString(source['id'] ?? source['_id']),
      name: _asString(source['name']),
    );
  }
}

String _asString(dynamic value) => value?.toString().trim() ?? '';
