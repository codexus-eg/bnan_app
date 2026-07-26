import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';

class CurriculumsResponseModel {
  const CurriculumsResponseModel({
    required this.success,
    required this.length,
    required this.data,
  });

  final bool success;
  final int length;
  final List<CurriculumModel> data;

  factory CurriculumsResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['data'] as List<dynamic>? ?? [];

    return CurriculumsResponseModel(
      success: json['success'] as bool? ?? false,
      length: json['length'] as int? ?? items.length,
      data: items
          .whereType<Map<String, dynamic>>()
          .map(CurriculumModel.fromJson)
          .toList(),
    );
  }
}
