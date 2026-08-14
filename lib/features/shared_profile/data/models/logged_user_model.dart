import 'package:bnan_app/core/helper/name_helper.dart';

import 'logged_user_grade_model.dart';
import 'logged_user_parent_model.dart';

class LoggedUserModel {
  final String id;
  final LoggedUserInfoModel user;
  final LoggedUserParentModel? parent;
  final String? curriculum;
  final String? curriculumName;
  final LoggedUserGradeModel? grade;
  final List<String> subjects;
  final String createdAt;
  final String updatedAt;
  final String? studentMode;

  const LoggedUserModel({
    required this.id,
    required this.user,
    required this.parent,
    required this.curriculum,
    this.curriculumName,
    required this.grade,
    required this.subjects,
    required this.createdAt,
    required this.updatedAt,
    this.studentMode,
  });
  String get firstTwoNames => NameHelper.getFirstTwoNames(user.fullName);
  String get gradeName => grade?.name ?? '';
  bool get isGulfStudent => studentMode?.toLowerCase() == 'gulf';

  factory LoggedUserModel.fromJson(Map<String, dynamic> json) {
    return LoggedUserModel(
      id: json['id'] ?? '',
      user: LoggedUserInfoModel.fromJson(_userJson(json)),
      parent: json['parent'] == null
          ? null
          : LoggedUserParentModel.fromJson(json['parent']),
      curriculum: _curriculumId(json['curriculum']),
      curriculumName: _curriculumName(json['curriculum']),
      grade: json['grade'] == null
          ? null
          : LoggedUserGradeModel.fromJson(json['grade']),
      subjects: _subjectNames(json['subjects'], grade: json['grade']),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      studentMode: _studentMode(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'parent': parent?.toJson(),
      'curriculum': curriculum,
      if (curriculumName != null) 'curriculumName': curriculumName,
      'grade': grade?.toJson(),
      'subjects': subjects,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (studentMode != null) 'mode': studentMode,
    };
  }

  factory LoggedUserModel.placeholder({
    String fullName = '',
    String email = '',
    String role = 'student',
  }) {
    return LoggedUserModel(
      id: '',
      user: LoggedUserInfoModel(
        id: '',
        fullName: fullName,
        email: email,
        role: role,
      ),
      parent: null,
      curriculum: null,
      grade: null,
      subjects: [],
      createdAt: '',
      updatedAt: '',
    );
  }
}

String? _studentMode(Map<String, dynamic> json) {
  final curriculum = json['curriculum'];
  final value =
      json['mode'] ??
      json['studentMode'] ??
      json['registrationMode'] ??
      (curriculum is Map ? curriculum['baseCurriculum'] : null);
  final normalized = value?.toString().trim().toLowerCase();
  return normalized == 'gulf' || normalized == 'egyptian' ? normalized : null;
}

String? _curriculumId(Object? value) {
  if (value is String) return value;
  if (value is Map) return (value['id'] ?? value['_id'])?.toString();
  return null;
}

class LoggedUserInfoModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String phone;

  const LoggedUserInfoModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.phone = '',
  });

  factory LoggedUserInfoModel.fromJson(Map<String, dynamic> json) {
    return LoggedUserInfoModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'phone': phone,
    };
  }
}

Map<String, dynamic> _userJson(Map<String, dynamic> json) {
  final user = json['user'];
  if (user is Map<String, dynamic>) return user;
  return json;
}

String? _curriculumName(Object? value) {
  if (value is Map) return value['name']?.toString();
  return null;
}

List<String> _subjectNames(Object? value, {Object? grade}) {
  if (value is! List) return const [];

  final gradeSubjects = grade is Map && grade['subjects'] is List
      ? grade['subjects'] as List
      : const [];

  return value
      .map((item) {
        if (item is Map) {
          return (item['name'] ?? item['id'] ?? item['_id'])?.toString().trim();
        }

        final subjectId = item.toString();

        for (final gradeSubject in gradeSubjects) {
          if (gradeSubject is Map) {
            final id = (gradeSubject['id'] ?? gradeSubject['_id'])?.toString();

            if (id == subjectId) {
              return gradeSubject['name']?.toString().trim();
            }
          }
        }

        return subjectId.trim();
      })
      .whereType<String>()
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}
