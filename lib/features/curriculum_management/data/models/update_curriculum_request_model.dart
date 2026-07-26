class UpdateCurriculumRequestModel {
  const UpdateCurriculumRequestModel({this.name, this.description});

  final String? name;
  final String? description;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name!.trim(),
      if (description != null) 'description': description!.trim(),
    };
  }
}
