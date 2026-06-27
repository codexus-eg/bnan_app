class TeacherClassroomStudentModel {
  final String id;
  final String studentId;
  final String userId;
  final String fullName;
  final String email;
  final String role;

  TeacherClassroomStudentModel({
    required this.id,
    required this.studentId,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory TeacherClassroomStudentModel.fromJson(Map<String, dynamic> json) {
    final student = json['student'] ?? {};
    final user = student['user'] ?? {};

    return TeacherClassroomStudentModel(
      id: json['id'] ?? '',
      studentId: student['id'] ?? '',
      userId: user['id'] ?? '',
      fullName: user['fullName'] ?? '',
      email: user['email'] ?? '',
      role: user['role'] ?? '',
    );
  }
}