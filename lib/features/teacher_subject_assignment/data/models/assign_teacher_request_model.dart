class AssignTeacherRequestModel {
  const AssignTeacherRequestModel({
    required this.curriculumId,
    required this.gradeId,
    required this.classroomId,
    required this.subjectId,
  });

  final String curriculumId;
  final String gradeId;
  final String classroomId;
  final String subjectId;

  Map<String, dynamic> toJson() => {
    'curriculum': curriculumId,
    'grade': gradeId,
    'classroom': classroomId,
    'subject': subjectId,
  };
}
