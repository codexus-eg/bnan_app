import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';

class ClassroomsResponseModel {
  const ClassroomsResponseModel({
    required this.success,
    required this.results,
    required this.pagination,
    required this.data,
  });

  final bool success;
  final int results;
  final ClassroomsPaginationModel pagination;
  final List<ClassroomModel> data;

  factory ClassroomsResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassroomsResponseModel(
      success: json['success'] ?? false,
      results: json['results'] ?? 0,
      pagination: ClassroomsPaginationModel.fromJson(
        json['pagination'] is Map
            ? Map<String, dynamic>.from(json['pagination'])
            : <String, dynamic>{},
      ),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ClassroomModel.fromJson(e))
          .toList(),
    );
  }
}

class ClassroomsPaginationModel {
  const ClassroomsPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  factory ClassroomsPaginationModel.fromJson(Map<String, dynamic> json) {
    return ClassroomsPaginationModel(
      currentPage: int.tryParse(json['currentPage']?.toString() ?? '') ?? 0,
      perPage: int.tryParse(json['perPage']?.toString() ?? '') ?? 0,
      total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
      lastPage: int.tryParse(json['lastPage']?.toString() ?? '') ?? 0,
    );
  }
}
