class SubjectsResponseModel {
  const SubjectsResponseModel({
    required this.success,
    required this.length,
    required this.data,
  });

  final bool success;
  final int length;
  final List<SubjectModel> data;

  factory SubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    return SubjectsResponseModel(
      success: json['success'] ?? false,
      length: json['length'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => SubjectModel.fromJson(item))
          .toList(),
    );
  }
}

class SubjectModel {
  const SubjectModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.curriculum,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final bool isActive;
  final SubjectCurriculumModel? curriculum;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
      curriculum: json['curriculum'] == null
          ? null
          : SubjectCurriculumModel.fromJson(json['curriculum']),
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }
  
}


class SubjectCurriculumModel {
  const SubjectCurriculumModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final String icon;

  factory SubjectCurriculumModel.fromJson(Map<String, dynamic> json) {
    return SubjectCurriculumModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}