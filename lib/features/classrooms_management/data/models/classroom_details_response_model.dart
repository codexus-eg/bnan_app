import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';

class ClassroomDetailsResponseModel {
  const ClassroomDetailsResponseModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final ClassroomModel data;

  factory ClassroomDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final classroomJson = rawData is Map
        ? (rawData['classroom'] is Map
            ? Map<String, dynamic>.from(rawData['classroom'] as Map)
            : Map<String, dynamic>.from(rawData))
        : <String, dynamic>{};
    return ClassroomDetailsResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      data: ClassroomModel.fromJson(classroomJson),
    );
  }
}
