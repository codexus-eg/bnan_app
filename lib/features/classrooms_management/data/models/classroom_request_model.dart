class ClassroomRequestModel {
  const ClassroomRequestModel({
    required this.name,
    this.curriculumId,
    this.gradeId,
    this.supervisorId,
  });

  final String name;
  final String? curriculumId;
  final String? gradeId;
  final String? supervisorId;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (curriculumId != null) 'curriculum': curriculumId,
      if (gradeId != null) 'grade': gradeId,
      if (supervisorId != null) 'supervisorId': supervisorId,
    };
  }
}
