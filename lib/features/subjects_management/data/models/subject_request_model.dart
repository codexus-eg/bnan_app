class AddSubjectRequestModel {
  const AddSubjectRequestModel({
    required this.name,
    required this.curriculumId,
    required this.gradeId,
  });
  final String name;
  final String curriculumId;
  final String gradeId;

  Map<String, dynamic> toJson() => {
    'name': name,
    'curriculum': curriculumId,
    'grade': gradeId,
  };
}

class UpdateSubjectRequestModel {
  const UpdateSubjectRequestModel({required this.name});

  final String name;

  Map<String, dynamic> toJson() => {'name': name};
}
