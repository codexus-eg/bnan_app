import 'teacher_assigned_subjects_data_model.dart';

class GetTeacherAssignedSubjectsResponseModel {
  const GetTeacherAssignedSubjectsResponseModel({
    required this.success,
    required this.results,
    required this.data,
  });

  final bool success;
  final int results;
  final TeacherAssignedSubjectsDataModel data;

  factory GetTeacherAssignedSubjectsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];

    return GetTeacherAssignedSubjectsResponseModel(
      success: json['success'] == true,
      results: json['results'] is num ? (json['results'] as num).toInt() : 0,
      data: TeacherAssignedSubjectsDataModel.fromJson(
        data is Map ? Map<String, dynamic>.from(data) : const {},
      ),
    );
  }
}
