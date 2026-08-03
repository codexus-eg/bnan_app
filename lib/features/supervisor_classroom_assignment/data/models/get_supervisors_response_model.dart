import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/supervisor_assignments_response_model.dart';

class GetSupervisorsResponseModel {
  const GetSupervisorsResponseModel({
    this.success = false,
    this.results = 0,
    this.pagination,
    this.data = const [],
  });

  final bool success;
  final int results;
  final SupervisorPaginationModel? pagination;
  final List<SupervisorModel> data;

  factory GetSupervisorsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetSupervisorsResponseModel(
      success: json['success'] == true,
      results: _asInt(json['results']),
      pagination: _nested(
        json['pagination'],
        SupervisorPaginationModel.fromJson,
      ),
      data: _models(json['data'], SupervisorModel.fromJson),
    );
  }
}

class SupervisorPaginationModel {
  const SupervisorPaginationModel({
    this.currentPage = 0,
    this.perPage = 0,
    this.total = 0,
    this.lastPage = 0,
  });

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  factory SupervisorPaginationModel.fromJson(Map<String, dynamic> json) {
    return SupervisorPaginationModel(
      currentPage: _asInt(json['currentPage']),
      perPage: _asInt(json['perPage']),
      total: _asInt(json['total']),
      lastPage: _asInt(json['lastPage']),
    );
  }
}

class SupervisorModel {
  const SupervisorModel({
    this.id = '',
    this.phone = '',
    this.user,
    this.curriculum,
    this.activeAssignmentCount = 0,
    this.assignments = const [],
    this.createdAt,
  });

  final String id;
  final String phone;
  final SupervisorUserModel? user;
  final SupervisorCurriculumModel? curriculum;
  final int activeAssignmentCount;
  final List<SupervisorAssignmentModel> assignments;
  final DateTime? createdAt;

  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    return SupervisorModel(
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      user: _nested(json['user'], SupervisorUserModel.fromJson),
      curriculum: _nested(
        json['curriculum'],
        SupervisorCurriculumModel.fromJson,
      ),
      activeAssignmentCount: _asInt(json['activeAssignmentCount']),
      assignments: _models(
        json['assignments'],
        SupervisorAssignmentModel.fromJson,
      ),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

class SupervisorUserModel {
  const SupervisorUserModel({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.role = '',
    this.status = '',
  });

  final String id;
  final String fullName;
  final String email;
  final String role;
  final String status;

  factory SupervisorUserModel.fromJson(Map<String, dynamic> json) {
    return SupervisorUserModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

class SupervisorCurriculumModel {
  const SupervisorCurriculumModel({this.id = '', this.name = ''});

  final String id;
  final String name;

  factory SupervisorCurriculumModel.fromJson(Map<String, dynamic> json) {
    return SupervisorCurriculumModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

int _asInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

T? _nested<T>(Object? value, T Function(Map<String, dynamic>) fromJson) {
  return value is Map ? fromJson(Map<String, dynamic>.from(value)) : null;
}

List<T> _models<T>(Object? value, T Function(Map<String, dynamic>) fromJson) {
  return value is List
      ? value
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .map(fromJson)
            .toList(growable: false)
      : const [];
}
