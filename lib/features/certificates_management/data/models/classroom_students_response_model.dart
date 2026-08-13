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
    return ClassroomStudentModel(
      id: (json['studentId'] ?? json['id'] ?? json['_id'])?.toString(),
      fullName: json['fullName'] as String?,
    );
  }
}
