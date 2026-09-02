class TeacherUserModel {
  final String fullName;
  final String email;
  final String status;
  final String id;

  TeacherUserModel({
    required this.fullName,
    required this.email,
    required this.status,
    required this.id,
  });

  factory TeacherUserModel.fromJson(Map<String, dynamic> json) {
    return TeacherUserModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      id: json['id'] ?? '',
    );
  }
}
