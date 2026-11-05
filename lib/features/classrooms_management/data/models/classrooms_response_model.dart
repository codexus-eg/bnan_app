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
      success: json['success'] == true || json['status'] == 'success',
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
    final curPage =
        int.tryParse(json['currentPage']?.toString() ?? '') ??
        int.tryParse(json['page']?.toString() ?? '') ??
        1;
    final limit =
        int.tryParse(json['perPage']?.toString() ?? '') ??
        int.tryParse(json['limit']?.toString() ?? '') ??
        20;
    final totalCount =
        int.tryParse(json['total']?.toString() ?? '') ??
        int.tryParse(json['totalCount']?.toString() ?? '') ??
        int.tryParse(json['totalResults']?.toString() ?? '') ??
        0;
    final totalPages =
        int.tryParse(json['lastPage']?.toString() ?? '') ??
        int.tryParse(json['numberOfPages']?.toString() ?? '') ??
        int.tryParse(json['totalPages']?.toString() ?? '') ??
        int.tryParse(json['pages']?.toString() ?? '') ??
        1;

    return ClassroomsPaginationModel(
      currentPage: curPage,
      perPage: limit,
      total: totalCount,
      lastPage: totalPages,
    );
  }
}
