class UnassignedStudentModel {
  final String id;
  final String fullName;
  final String registrationMode;
  final String status;
  final bool? isActive;
  final StudentLookupModel? curriculum;
  final StudentLookupModel? grade;

  const UnassignedStudentModel({
    required this.id,
    required this.fullName,
    this.registrationMode = '',
    this.status = '',
    this.isActive,
    this.curriculum,
    this.grade,
  });

  factory UnassignedStudentModel.fromJson(Map<String, dynamic> json) {
    return UnassignedStudentModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      registrationMode: json['registrationMode']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      isActive: json['isActive'] is bool ? json['isActive'] as bool : null,
      curriculum: json['curriculum'] == null
          ? null
          : StudentLookupModel.fromJson(json['curriculum']),
      grade: json['grade'] == null
          ? null
          : StudentLookupModel.fromJson(json['grade']),
    );
  }

  bool get hasActiveAccount =>
      isActive ?? status.trim().toLowerCase() == 'active';
}

class StudentLookupModel {
  final String id;
  final String name;

  const StudentLookupModel({required this.id, required this.name});

  factory StudentLookupModel.fromJson(Map<String, dynamic> json) {
    return StudentLookupModel(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}
