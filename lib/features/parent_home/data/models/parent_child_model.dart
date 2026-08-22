import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_curriculum_model.dart';

class ParentChildModel {
  const ParentChildModel({
    this.id = '',
    this.userId = '',
    String? fullName,
    String? name,
    this.classroom,
    String? grade,
    this.registrationMode,
    this.curriculum,
    this.directGrade,
    this.accountStatus,
  }) : fullName = fullName ?? name ?? '',
       _legacyGrade = grade ?? '';

  final String id;
  final String userId;
  final String fullName;
  final ParentChildClassroomModel? classroom;
  final RegistrationMode? registrationMode;
  final ParentChildCurriculumModel? curriculum;
  final ParentChildGradeModel? directGrade;
  final String _legacyGrade;
  final String? accountStatus;

  String get name => fullName;
  String get grade =>
      directGrade?.name ?? classroom?.grade?.name ?? _legacyGrade;
  bool? get isActive => switch (accountStatus?.trim().toLowerCase()) {
    'active' || 'activated' => true,
    'inactive' || 'deactivated' => false,
    _ => null,
  };

  factory ParentChildModel.fromJson(Map<String, dynamic> json) {
    final classroom = json['classroom'];
    final directGrade = json['grade'];
    final curriculum = ParentChildCurriculumModel.fromChildJson(json);
    return ParentChildModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString(),
      name: json['name']?.toString(),
      accountStatus: json['accountStatus']?.toString(),
      grade: directGrade is Map ? null : directGrade?.toString(),
      directGrade: directGrade is Map
          ? ParentChildGradeModel.fromJson(
              Map<String, dynamic>.from(directGrade),
            )
          : null,
      registrationMode:
          RegistrationMode.fromValue(json['registrationMode']) ??
          curriculum.registrationMode,
      curriculum: curriculum.id.isEmpty ? null : curriculum,
      classroom: classroom is Map
          ? ParentChildClassroomModel.fromJson(
              Map<String, dynamic>.from(classroom),
            )
          : null,
    );
  }
}

class ParentChildClassroomModel {
  const ParentChildClassroomModel({this.id = '', this.name = '', this.grade});

  final String id;
  final String name;
  final ParentChildGradeModel? grade;

  factory ParentChildClassroomModel.fromJson(Map<String, dynamic> json) {
    final grade = json['grade'];
    return ParentChildClassroomModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      grade: grade is Map
          ? ParentChildGradeModel.fromJson(Map<String, dynamic>.from(grade))
          : null,
    );
  }
}

class ParentChildGradeModel {
  const ParentChildGradeModel({this.name = ''});

  final String name;

  factory ParentChildGradeModel.fromJson(Map<String, dynamic> json) {
    return ParentChildGradeModel(name: json['name']?.toString() ?? '');
  }
}
