class ClassroomRequestModel {
  const ClassroomRequestModel({
    required this.name,
    this.curriculumId,
    this.gradeId,
  });

  final String name;
  final String? curriculumId;
  final String? gradeId;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (curriculumId != null) 'curriculum': curriculumId,
      if (gradeId != null) 'grade': gradeId,
    };
  }
}
