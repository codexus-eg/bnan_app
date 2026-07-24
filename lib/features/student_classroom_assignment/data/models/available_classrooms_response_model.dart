import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';

class AvailableClassroomsResponseModel {
  final UnassignedStudentInfoModel? student;
  final List<AvailableClassroomModel> classrooms;

  const AvailableClassroomsResponseModel({
    this.student,
    required this.classrooms,
  });

  factory AvailableClassroomsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] ?? {};

    return AvailableClassroomsResponseModel(
      student: data['student'] == null
          ? null
          : UnassignedStudentInfoModel.fromJson(data['student']),
      classrooms: (data['classrooms'] as List? ?? [])
          .map((e) => AvailableClassroomModel.fromJson(e))
          .toList(),
    );
  }
}

class UnassignedStudentInfoModel {
  final String id;
  final StudentLookupModel? curriculum;
  final StudentLookupModel? grade;

  const UnassignedStudentInfoModel({
    required this.id,
    this.curriculum,
    this.grade,
  });

  factory UnassignedStudentInfoModel.fromJson(Map<String, dynamic> json) {
    return UnassignedStudentInfoModel(
      id: json['id'] ?? '',
      curriculum: json['curriculum'] == null
          ? null
          : StudentLookupModel.fromJson(json['curriculum']),
      grade: json['grade'] == null
          ? null
          : StudentLookupModel.fromJson(json['grade']),
    );
  }
}

class AvailableClassroomModel {
  final String id;
  final String name;

  const AvailableClassroomModel({
    required this.id,
    required this.name,
  });

  factory AvailableClassroomModel.fromJson(Map<String, dynamic> json) {
    return AvailableClassroomModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}