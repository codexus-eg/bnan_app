class AddSubjectRequestModel {
  const AddSubjectRequestModel({
    required this.name,
    required this.curriculumId,
    required this.gradeIds,
  });
  final String name;
  final String curriculumId;
  final List<String> gradeIds;

  Map<String, dynamic> toJson() => {
    'name': name,
    'curriculum': curriculumId,
    'grades': gradeIds,
  };
}

class UpdateSubjectRequestModel {
  const UpdateSubjectRequestModel({required this.name, required this.gradeIds});

  final String name;
  final List<String> gradeIds;

  Map<String, dynamic> toJson() => {'name': name, 'grades': gradeIds};
}
