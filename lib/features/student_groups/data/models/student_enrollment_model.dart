class StudentEnrollmentsResponseModel {
  final List<StudentEnrollmentModel> enrollments;

  const StudentEnrollmentsResponseModel({
    required this.enrollments,
  });

  factory StudentEnrollmentsResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentEnrollmentsResponseModel(
      enrollments: (json['data'] as List<dynamic>?)
              ?.map((item) => StudentEnrollmentModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class StudentEnrollmentModel {
  final String id;
  final EnrollmentClassroomModel classroom;
  final String status;
  final String joinedAt;
  final String createdAt;
  final String updatedAt;

  const StudentEnrollmentModel({
    required this.id,
    required this.classroom,
    required this.status,
    required this.joinedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return StudentEnrollmentModel(
      id: json['id'] ?? '',
      classroom: EnrollmentClassroomModel.fromJson(json['classroom'] ?? {}),
      status: json['status'] ?? '',
      joinedAt: json['joinedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  factory StudentEnrollmentModel.placeholder() {
    return const StudentEnrollmentModel(
      id: '',
      classroom: EnrollmentClassroomModel(
        id: '',
        name: 'Math - Mr. Test',
      ),
      status: 'approved',
      joinedAt: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  static List<StudentEnrollmentModel> placeholderList() {
    return List.generate(
      4,
      (_) => StudentEnrollmentModel.placeholder(),
    );
  }

  bool get isPending => status == 'pending';

  bool get isApproved => status == 'approved';
}

class EnrollmentClassroomModel {
  final String id;
  final String name;

  const EnrollmentClassroomModel({
    required this.id,
    required this.name,
  });

  factory EnrollmentClassroomModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentClassroomModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}