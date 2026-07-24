class AssignStudentResponseModel {
  final AssignedEnrollmentModel? enrollment;

  const AssignStudentResponseModel({
    this.enrollment,
  });

  factory AssignStudentResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return AssignStudentResponseModel(
      enrollment: data['enrollment'] == null
          ? null
          : AssignedEnrollmentModel.fromJson(data['enrollment']),
    );
  }
}

class AssignedEnrollmentModel {
  final String id;
  final AssignedStudentModel? student;
  final AssignedClassroomModel? classroom;
  final String status;
  final String joinedAt;

  const AssignedEnrollmentModel({
    required this.id,
    this.student,
    this.classroom,
    required this.status,
    required this.joinedAt,
  });

  factory AssignedEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return AssignedEnrollmentModel(
      id: json['id'] ?? '',
      student: json['student'] == null
          ? null
          : AssignedStudentModel.fromJson(json['student']),
      classroom: json['classroom'] == null
          ? null
          : AssignedClassroomModel.fromJson(json['classroom']),
      status: json['status'] ?? '',
      joinedAt: json['joinedAt'] ?? '',
    );
  }
}

class AssignedStudentModel {
  final String id;
  final String fullName;

  const AssignedStudentModel({
    required this.id,
    required this.fullName,
  });

  factory AssignedStudentModel.fromJson(Map<String, dynamic> json) {
    return AssignedStudentModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}

class AssignedClassroomModel {
  final String id;
  final String name;

  const AssignedClassroomModel({
    required this.id,
    required this.name,
  });

  factory AssignedClassroomModel.fromJson(Map<String, dynamic> json) {
    return AssignedClassroomModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}