import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';

class CreateGradeResponseModel {
  const CreateGradeResponseModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final GradeModel data;

  factory CreateGradeResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateGradeResponseModel(
      success: json['success'] ?? false,
      data: GradeModel.fromJson(json['data'] ?? {}),
    );
  }
}