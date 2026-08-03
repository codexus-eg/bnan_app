class AssignCurriculumsResponseModel {
  final bool success;
  final bool assigned;
  final bool alreadyAssigned;
  final AssignCurriculumsData data;

  AssignCurriculumsResponseModel({
    required this.success,
    required this.assigned,
    required this.alreadyAssigned,
    required this.data,
  });

  factory AssignCurriculumsResponseModel.fromJson(Map<String, dynamic> json) {
    return AssignCurriculumsResponseModel(
      success: json['success'] ?? false,
      assigned: json['assigned'] ?? false,
      alreadyAssigned: json['alreadyAssigned'] ?? false,
      data: AssignCurriculumsData.fromJson(json['data'] ?? {}),
    );
  }
}

class AssignCurriculumsData {
  final AssignCurriculumsTeacher teacher;

  AssignCurriculumsData({required this.teacher});

  factory AssignCurriculumsData.fromJson(Map<String, dynamic> json) {
    return AssignCurriculumsData(
      teacher: AssignCurriculumsTeacher.fromJson(json['teacher'] ?? {}),
    );
  }
}

class AssignCurriculumsTeacher {
  final String id;
  final List<String> curriculums;

  AssignCurriculumsTeacher({required this.id, required this.curriculums});

  factory AssignCurriculumsTeacher.fromJson(Map<String, dynamic> json) {
    return AssignCurriculumsTeacher(
      id: _asString(json['_id'] ?? json['id']),
      curriculums: _asList(json['curriculums']),
    );
  }
}

String _asString(Object? value) => value?.toString().trim() ?? '';

List<String> _asList(Object? value) {
  final values = value is List ? value : [if (value != null) value];
  return values.map(_asString).where((value) => value.isNotEmpty).toList();
}
