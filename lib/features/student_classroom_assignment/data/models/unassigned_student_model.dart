class UnassignedStudentModel {
  final String id;
  final String fullName;
  final StudentLookupModel? curriculum;
  final StudentLookupModel? grade;

  const UnassignedStudentModel({
    required this.id,
    required this.fullName,
    this.curriculum,
    this.grade,
  });

  factory UnassignedStudentModel.fromJson(Map<String, dynamic> json) {
    return UnassignedStudentModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      curriculum: json['curriculum'] == null
          ? null
          : StudentLookupModel.fromJson(json['curriculum']),
      grade: json['grade'] == null
          ? null
          : StudentLookupModel.fromJson(json['grade']),
    );
  }
}

class StudentLookupModel {
  final String id;
  final String name;

  const StudentLookupModel({
    required this.id,
    required this.name,
  });

  factory StudentLookupModel.fromJson(Map<String, dynamic> json) {
    return StudentLookupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}