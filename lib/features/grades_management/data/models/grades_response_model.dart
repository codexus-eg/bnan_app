import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';

class GradesResponseModel {
  const GradesResponseModel({
    required this.success,
    required this.length,
    required this.data,
    this.currentPage,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
  });

  final bool success;
  final int length;
  final int? currentPage;
  final int? totalCount;
  final int? totalPages;
  final bool? hasNextPage;
  final List<GradeModel> data;

  factory GradesResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List? ?? [])
        .whereType<Map>()
        .map((item) => GradeModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    return GradesResponseModel(
      success: json['success'] == true,
      length: json['length'] is num
          ? (json['length'] as num).toInt()
          : list.length,
      currentPage: json['currentPage'] is num
          ? (json['currentPage'] as num).toInt()
          : null,
      totalCount: json['totalCount'] is num
          ? (json['totalCount'] as num).toInt()
          : null,
      totalPages: json['totalPages'] is num
          ? (json['totalPages'] as num).toInt()
          : null,
      hasNextPage: json['hasNextPage'] as bool?,
      data: list,
    );
  }
}
