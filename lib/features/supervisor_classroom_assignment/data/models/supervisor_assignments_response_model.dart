class SupervisorAssignmentsResponseModel {
  const SupervisorAssignmentsResponseModel({
    this.success = false,
    this.results = 0,
    this.data = const [],
  });

  final bool success;
  final int results;
  final List<SupervisorAssignmentModel> data;

  factory SupervisorAssignmentsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];
    return SupervisorAssignmentsResponseModel(
      success: json['success'] == true,
      results: _asInt(json['results']),
      data: data is List
          ? data
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .map(SupervisorAssignmentModel.fromJson)
                .toList(growable: false)
          : const [],
    );
  }
}

class SupervisorAssignmentModel {
  const SupervisorAssignmentModel({
    this.assignmentId = '',
    this.classroom,
    this.grade,
    this.curriculum,
    this.assignedAt,
    this.assignedBy,
  });

  final String assignmentId;
  final SupervisorAssignmentClassroomModel? classroom;
  final SupervisorAssignmentGradeModel? grade;
  final SupervisorAssignmentCurriculumModel? curriculum;
  final DateTime? assignedAt;
  final SupervisorAssignmentAssignedByModel? assignedBy;

  factory SupervisorAssignmentModel.fromJson(Map<String, dynamic> json) {
    return SupervisorAssignmentModel(
      assignmentId: json['assignmentId']?.toString() ?? '',
      classroom: _nested(
        json['classroom'],
        SupervisorAssignmentClassroomModel.fromJson,
      ),
      grade: _nested(json['grade'], SupervisorAssignmentGradeModel.fromJson),
      curriculum: _nested(
        json['curriculum'],
        SupervisorAssignmentCurriculumModel.fromJson,
      ),
      assignedAt: DateTime.tryParse(json['assignedAt']?.toString() ?? ''),
      assignedBy: _nested(
        json['assignedBy'],
        SupervisorAssignmentAssignedByModel.fromJson,
      ),
    );
  }
}

class SupervisorAssignmentClassroomModel {
  const SupervisorAssignmentClassroomModel({this.id = '', this.name = ''});
  final String id;
  final String name;

  factory SupervisorAssignmentClassroomModel.fromJson(
    Map<String, dynamic> json,
  ) => SupervisorAssignmentClassroomModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
  );
}

class SupervisorAssignmentGradeModel {
  const SupervisorAssignmentGradeModel({this.id = '', this.name = ''});
  final String id;
  final String name;

  factory SupervisorAssignmentGradeModel.fromJson(Map<String, dynamic> json) =>
      SupervisorAssignmentGradeModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
}

class SupervisorAssignmentCurriculumModel {
  const SupervisorAssignmentCurriculumModel({this.id = '', this.name = ''});
  final String id;
  final String name;

  factory SupervisorAssignmentCurriculumModel.fromJson(
    Map<String, dynamic> json,
  ) => SupervisorAssignmentCurriculumModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
  );
}

class SupervisorAssignmentAssignedByModel {
  const SupervisorAssignmentAssignedByModel({
    this.id = '',
    this.fullName = '',
    this.email = '',
  });

  final String id;
  final String fullName;
  final String email;

  factory SupervisorAssignmentAssignedByModel.fromJson(
    Map<String, dynamic> json,
  ) => SupervisorAssignmentAssignedByModel(
    id: json['id']?.toString() ?? '',
    fullName: json['fullName']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
  );
}

int _asInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

T? _nested<T>(Object? value, T Function(Map<String, dynamic>) fromJson) {
  return value is Map ? fromJson(Map<String, dynamic>.from(value)) : null;
}
