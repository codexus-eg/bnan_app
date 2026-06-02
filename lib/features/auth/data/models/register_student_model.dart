class RegisterStudentModel {
  const RegisterStudentModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.grade,
    required this.subjects,
  });

  final String fullName;
  final String email;
  final String password;
  final String grade;
  final List<String> subjects;

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'grade': grade,
      'subjects': subjects,
    };
  }
}