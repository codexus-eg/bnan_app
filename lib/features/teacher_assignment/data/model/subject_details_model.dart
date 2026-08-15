class SubjectDetailsModel {
  final String id;
  final String subjectId;
  final String name;

  const SubjectDetailsModel({
    required this.id,
    required this.subjectId,
    required this.name,
  });

  factory SubjectDetailsModel.fromJson(Map<String, dynamic> json) {
    final nestedData = json['data'];
    final data = nestedData is Map
        ? Map<String, dynamic>.from(nestedData)
        : json;

    return SubjectDetailsModel(
      id: _asString(data['id'] ?? data['_id']),
      subjectId: _asString(
        data['subjectId'] ??
            (data['subject'] is Map ? data['subject']['id'] : null),
      ),
      name: _asString(data['name']),
    );
  }
}

String _asString(dynamic value) => value?.toString().trim() ?? '';