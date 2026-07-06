class CreateGradeRequestModel {
  const CreateGradeRequestModel({
    required this.name,
    required this.curriculumId,
  });

  final String name;
  final String curriculumId;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'curriculum': curriculumId,
    };
  }
}