import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';

class GradesResponseModel {
  const GradesResponseModel({
    required this.success,
    required this.length,
    required this.data,
  });

  final bool success;
  final int length;
  final List<GradeModel> data;

  factory GradesResponseModel.fromJson(Map<String, dynamic> json) {
    return GradesResponseModel(
      success: json['success'] ?? false,
      length: json['length'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((item) => GradeModel.fromJson(item))
          .toList(),
    );
  }
}