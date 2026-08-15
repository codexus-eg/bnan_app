import 'package:bnan_app/core/enums/registration_mode.dart';

class TeacherClassroomModel {
  final String id;
  final String name;
  final RegistrationMode? registrationMode;

  const TeacherClassroomModel({
    required this.id,
    required this.name,
    this.registrationMode,
  });

  factory TeacherClassroomModel.fromJson(Map<String, dynamic> json) {
    final nestedClassroom = json['classroom'];
    final classroom = nestedClassroom is Map
        ? Map<String, dynamic>.from(nestedClassroom)
        : json;
    final curriculum = classroom['curriculum'];
    final curriculumData = curriculum is Map
        ? Map<String, dynamic>.from(curriculum)
        : const <String, dynamic>{};

    return TeacherClassroomModel(
      id: _asString(classroom['id'] ?? classroom['_id']),
      name: _asString(classroom['name']),
      registrationMode: RegistrationMode.fromValue(
        classroom['registrationMode'] ??
            curriculumData['registrationMode'] ??
            json['registrationMode'],
      ),
    );
  }

  factory TeacherClassroomModel.placeholder() {
    return const TeacherClassroomModel(id: '', name: 'Math - Mr. Test');
  }
}

String _asString(dynamic value) => value?.toString().trim() ?? '';
