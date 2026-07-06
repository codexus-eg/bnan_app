class ClassRequestModel {
  const ClassRequestModel({
    required this.name,
    required this.curriculumId,
    required this.gradeId,
  });

  final String name;
  final String curriculumId;
  final String gradeId;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'curriculum': curriculumId,
      'grade': gradeId,
    };
  }
}