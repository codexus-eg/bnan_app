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

  const LoggedUserModel({
    required this.id,
    required this.user,
    required this.parent,
    required this.curriculum,
    required this.grade,
    required this.subjects,
    required this.createdAt,
    required this.updatedAt,
  });
  String get firstTwoNames => NameHelper.getFirstTwoNames(user.fullName);
  String get gradeName => grade?.name ?? '';

  factory LoggedUserModel.fromJson(Map<String, dynamic> json) {
    return LoggedUserModel(
      id: json['id'] ?? '',
      user: LoggedUserInfoModel.fromJson(json['user'] ?? {}),
      parent: json['parent'] == null
          ? null
          : LoggedUserParentModel.fromJson(json['parent']),
      curriculum: json['curriculum'],
      grade: json['grade'] == null
          ? null
          : LoggedUserGradeModel.fromJson(json['grade']),
      subjects: List<String>.from(json['subjects'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
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
