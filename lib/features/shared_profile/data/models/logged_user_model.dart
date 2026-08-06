import 'package:bnan_app/core/helper/name_helper.dart';

import 'logged_user_grade_model.dart';
import 'logged_user_parent_model.dart';

class LoggedUserModel {
  final String id;
  final LoggedUserInfoModel user;
  final LoggedUserParentModel? parent;
  final String? curriculum;
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
      user: LoggedUserInfoModel.fromJson(json['user'] ?? {}),
      parent: json['parent'] == null
          ? null
          : LoggedUserParentModel.fromJson(json['parent']),
      curriculum: _curriculumId(json['curriculum']),
      grade: json['grade'] == null
          ? null
          : LoggedUserGradeModel.fromJson(json['grade']),
      subjects: List<String>.from(json['subjects'] ?? []),
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
      'grade': grade?.toJson(),
      'subjects': subjects,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (studentMode != null) 'mode': studentMode,
    };
  }

  factory LoggedUserModel.placeholder() {
    return const LoggedUserModel(
      id: '',
      user: LoggedUserInfoModel(
        id: '',
        fullName: 'اسم الطالب',
        email: 'student@email.com',
        role: 'student',
      ),
      parent: LoggedUserParentModel(id: '', phone: '+20 100 000 0000'),
      curriculum: 'المنهج',
      grade: LoggedUserGradeModel(id: '', name: 'الصف الدراسي'),
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

  const LoggedUserInfoModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory LoggedUserInfoModel.fromJson(Map<String, dynamic> json) {
    return LoggedUserInfoModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fullName': fullName, 'email': email, 'role': role};
  }
}
