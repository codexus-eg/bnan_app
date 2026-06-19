class GradesResponseModel {
  final bool success;
  final List<GradeModel> grades;

  const GradesResponseModel({
    required this.success,
    required this.grades,
  });

  factory GradesResponseModel.fromJson(Map<String, dynamic> json) {
    return GradesResponseModel(
      success: json['success'] ?? false,
      grades: (json['data'] as List<dynamic>? ?? [])
          .map((item) => GradeModel.fromJson(item))
          .toList(),
    );
  }
}

class GradeModel {
  final String id;
  final String name;
  final String curriculum;
  final bool isActive;

  const GradeModel({
    required this.id,
    required this.name,
    required this.curriculum,
    required this.isActive,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      curriculum: json['curriculum'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}