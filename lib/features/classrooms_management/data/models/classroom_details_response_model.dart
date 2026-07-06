import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';

class ClassroomDetailsResponseModel {
  const ClassroomDetailsResponseModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final ClassroomModel data;

  factory ClassroomDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassroomDetailsResponseModel(
      success: json['success'] ?? false,
      data: ClassroomModel.fromJson(json['data'] ?? {}),
    );
  }
}