class ParentChildStudentRequest {
  const ParentChildStudentRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.gradeId,
    required this.subjectIds,
  });

  final String fullName;
  final String email;
  final String password;
  final String gradeId;
  final List<String> subjectIds;

  Map<String, dynamic> toJson() => {
    'fullName': fullName.trim(),
    'email': email.trim(),
    'password': password,
    'grade': gradeId,
    'subjects': List<String>.unmodifiable(subjectIds),
  };
}
