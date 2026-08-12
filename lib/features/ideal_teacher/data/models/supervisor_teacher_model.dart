import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_parser.dart';

class SupervisorTeacherModel {
  const SupervisorTeacherModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.subjects,
    required this.classrooms,
  });

  factory SupervisorTeacherModel.fromJson(Object? json) {
    final data = IdealTeacherParser.map(json);
    final teacher = IdealTeacherParser.map(data['teacher']);
    final user = IdealTeacherParser.map(data['user'] ?? teacher['user']);
    String read(String key) =>
        IdealTeacherParser.text(data[key] ?? teacher[key] ?? user[key]);
    return SupervisorTeacherModel(
      id: read('teacherId').isNotEmpty
          ? read('teacherId')
          : IdealTeacherParser.text(
              data['id'] ??
                  data['_id'] ??
                  teacher['id'] ??
                  teacher['_id'] ??
                  user['id'] ??
                  user['_id'],
            ),
      name: read('fullName').isNotEmpty ? read('fullName') : read('name'),
      avatar: read('avatar').isNotEmpty ? read('avatar') : read('avatarUrl'),
      subjects: IdealTeacherParser.labels(
        data['subjects'] ?? teacher['subjects'],
      ),
      classrooms: IdealTeacherParser.labels(
        data['classrooms'] ?? teacher['classrooms'],
      ),
    );
  }

  final String id, name, avatar;
  final List<String> subjects, classrooms;
}
