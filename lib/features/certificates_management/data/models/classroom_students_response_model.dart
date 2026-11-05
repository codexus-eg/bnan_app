class ClassroomStudentsResponseModel {
  const ClassroomStudentsResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  final bool? success;
  final int? count;
  final List<ClassroomStudentModel> data;

  factory ClassroomStudentsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClassroomStudentsResponseModel(
      success: json['success'] as bool?,
      count: json['count'] as int?,
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (item) => ClassroomStudentModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class ClassroomStudentModel {
  const ClassroomStudentModel({
    required this.id,
    required this.fullName,
  });

  final String? id;
  final String? fullName;

  factory ClassroomStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawStudentId = json['studentId'];
    final studentIdMap = rawStudentId is Map<String, dynamic>
        ? rawStudentId
        : null;
    final studentMap = json['student'] is Map<String, dynamic>
        ? json['student'] as Map<String, dynamic>
        : (json['studentProfile'] is Map<String, dynamic>
            ? json['studentProfile'] as Map<String, dynamic>
            : (json['profile'] is Map<String, dynamic>
                ? json['profile'] as Map<String, dynamic>
                : studentIdMap));
    return ClassroomStudentModel(
      id: (rawStudentId is String ? rawStudentId : null) ??
          json['studentProfileId']?.toString() ??
          studentMap?['studentId']?.toString() ??
          studentMap?['id']?.toString() ??
          studentMap?['_id']?.toString() ??
          json['id']?.toString() ??
          json['_id']?.toString(),
      fullName: (json['fullName'] ??
              json['name'] ??
              studentMap?['fullName'] ??
              studentMap?['name'] ??
              json['user']?['fullName'])
          as String?,
    );
  }
}
