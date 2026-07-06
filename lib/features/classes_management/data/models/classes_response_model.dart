import 'package:bnan_app/features/classes_management/data/models/class_model.dart';

class ClassesResponseModel {
  const ClassesResponseModel({
    required this.success,
    required this.results,
    required this.data,
  });

  final bool success;
  final int results;
  final List<ClassModel> data;

  factory ClassesResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassesResponseModel(
      success: json['success'] ?? false,
      results: json['results'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ClassModel.fromJson(e))
          .toList(),
    );
  }
}