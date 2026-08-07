import 'package:bnan_app/core/enums/registration_mode.dart';

class ParentChildModel {
  const ParentChildModel({
    this.id = '',
    String? fullName,
    String? name,
    this.classroom,
    String? grade,
    this.registrationMode,
  }) : fullName = fullName ?? name ?? '',
       _legacyGrade = grade ?? '';

  final String id;
  final String fullName;
  final ParentChildClassroomModel? classroom;
  final RegistrationMode? registrationMode;
  final String _legacyGrade;

  String get name => fullName;
  String get grade => classroom?.grade?.name ?? _legacyGrade;

  factory ParentChildModel.fromJson(Map<String, dynamic> json) {
    final classroom = json['classroom'];
    return ParentChildModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      fullName: json['fullName']?.toString(),
      name: json['name']?.toString(),
      grade: json['grade']?.toString(),
      registrationMode: RegistrationMode.fromValue(json['registrationMode']),
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
