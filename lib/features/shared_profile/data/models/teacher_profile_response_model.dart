import 'package:bnan_app/core/enums/registration_mode.dart';

class TeacherProfileResponseModel {
  final bool success;
  final TeacherProfileModel teacherProfile;

  TeacherProfileResponseModel({
    required this.success,
    required this.teacherProfile,
  });

  factory TeacherProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileResponseModel(
      success: json['success'] ?? false,
      teacherProfile: TeacherProfileModel.fromJson(json['data'] ?? {}),
    );
  }
}

class TeacherProfileModel {
  final String id;
  final TeacherProfileUserModel user;
  final String phone;
  final String specialization;
  final List<RegistrationMode> registrationModes;
  final List<TeacherProfileItemModel> curriculums;
  final int grades;
  final List<TeacherProfileItemModel> subjects;
  final int classrooms;
  final int students;

  TeacherProfileModel({
    required this.id,
    required this.user,
    required this.phone,
    required this.specialization,
    required this.registrationModes,
    required this.curriculums,
    required this.grades,
    required this.subjects,
    required this.classrooms,
    required this.students,
  });

  factory TeacherProfileModel.placeholder() {
    return TeacherProfileModel(
      id: '',
      user: TeacherProfileUserModel.placeholder(),
      phone: '',
      specialization: '',
      registrationModes: const [],
      curriculums: const [],
      grades: 0,
      subjects: const [],
      classrooms: 0,
      students: 0,
    );
  }

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      user: TeacherProfileUserModel.fromJson(json['user'] ?? {}),
      phone: json['phone'] ?? '',
      specialization: json['specialization'] ?? '',
      registrationModes: RegistrationMode.fromList(json['registrationModes']),
      curriculums: _items(json['curriculums']),
      grades: _count(json['grades']),
      subjects: _items(json['subjects']),
      classrooms: _count(json['classrooms']),
      students: _count(json['students']),
    );
  }
}

class TeacherProfileUserModel {
  final String id;
  final String fullName;
  final String email;

  TeacherProfileUserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory TeacherProfileUserModel.placeholder() {
    return TeacherProfileUserModel(id: '', fullName: '', email: '');
  }

  factory TeacherProfileUserModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileUserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class TeacherProfileItemModel {
  final String id;
  final String name;

  TeacherProfileItemModel({required this.id, required this.name});

  factory TeacherProfileItemModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileItemModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

int _count(Object? value) {
  if (value is num) return value.toInt();
  if (value is List) return value.length;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

List<TeacherProfileItemModel> _items(Object? value) {
  if (value is! List) return const [];
  return value
      .map((item) {
        if (item is Map<String, dynamic>) {
          return TeacherProfileItemModel.fromJson(item);
        }
        return TeacherProfileItemModel(
          id: item.toString(),
          name: item.toString(),
        );
      })
      .toList(growable: false);
}
