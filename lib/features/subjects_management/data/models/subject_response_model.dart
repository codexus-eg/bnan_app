import 'package:bnan_app/features/subjects_management/data/models/subjects_pagination_model.dart';

class SubjectsResponseModel {
  const SubjectsResponseModel({
    required this.success,
    required this.length,
    required this.data,
    this.pagination = const SubjectsPaginationModel(
      currentPage: 1,
      perPage: 0,
      total: 0,
      lastPage: 1,
    ),
  });

  final bool success;
  final int length;
  final List<SubjectModel> data;
  final SubjectsPaginationModel pagination;

  factory SubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? [])
        .map((item) => SubjectModel.fromJson(item))
        .toList();
    final pagination = json['pagination'];
    return SubjectsResponseModel(
      success: json['success'] ?? false,
      length: json['length'] ?? 0,
      data: data,
      pagination: pagination is Map
          ? SubjectsPaginationModel.fromJson(
              Map<String, dynamic>.from(pagination),
            )
          : SubjectsPaginationModel(
              currentPage: 1,
              perPage: data.length,
              total: data.length,
              lastPage: 1,
            ),
    );
  }
}

class SubjectModel {
  const SubjectModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.curriculum,
    this.grade,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final bool isActive;
  final SubjectCurriculumModel? curriculum;
  final SubjectGradeModel? grade;
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
      grade: json['grade'] is Map
          ? SubjectGradeModel.fromJson(Map<String, dynamic>.from(json['grade']))
          : null,
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

class SubjectGradeModel {
  const SubjectGradeModel({this.id, this.name});

  final String? id;
  final String? name;

  factory SubjectGradeModel.fromJson(Map<String, dynamic> json) {
    return SubjectGradeModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
    );
  }
}
