class SubjectRequestModel {
  const SubjectRequestModel({
    required this.name,
    this.curriculum,
    this.grade,
  });

  final String name;
  final String? curriculum;
  final String? grade;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (curriculum != null) 'curriculum': curriculum,
      if (grade != null) 'grade': grade,
    };
  }
}