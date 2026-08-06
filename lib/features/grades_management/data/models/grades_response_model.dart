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
      success: json['success'] == true,
      length: json['length'] is num
          ? (json['length'] as num).toInt()
          : (json['data'] as List? ?? []).length,
      data: (json['data'] as List? ?? [])
          .whereType<Map>()
          .map((item) => GradeModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}
