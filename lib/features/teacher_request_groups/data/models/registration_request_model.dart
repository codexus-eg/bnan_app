class RegistrationRequestModel {
  const RegistrationRequestModel({
    required this.studentName,
    required this.daysAgo,
    required this.subjectName,
    required this.gradeName,
    required this.curriculumName,
    required this.teacherName,
  });

  final String studentName;
  final int daysAgo;
  final String subjectName;
  final String gradeName;
  final String curriculumName;
  final String teacherName;
}