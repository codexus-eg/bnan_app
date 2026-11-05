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
    final subjects = <String>{
      ...IdealTeacherParser.labels(data['subjects'] ?? teacher['subjects']),
    };
    final classrooms = <String>{
      ...IdealTeacherParser.labels(data['classrooms'] ?? teacher['classrooms']),
    };
    if (data['curriculums'] is List) {
      for (final c in IdealTeacherParser.list(data['curriculums'])) {
        final cMap = IdealTeacherParser.map(c);
        for (final g in IdealTeacherParser.list(cMap['grades'])) {
          final gMap = IdealTeacherParser.map(g);
          for (final s in IdealTeacherParser.list(gMap['subjects'])) {
            final sMap = IdealTeacherParser.map(s);
            final sName = IdealTeacherParser.text(sMap['name'] ?? sMap['title']);
            if (sName.isNotEmpty) subjects.add(sName);
            for (final cl in IdealTeacherParser.list(sMap['classrooms'])) {
              final clMap = IdealTeacherParser.map(cl);
              final clName = IdealTeacherParser.text(clMap['name'] ?? clMap['title']);
              if (clName.isNotEmpty) classrooms.add(clName);
            }
          }
        }
      }
    }
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
      name: read('fullName').isNotEmpty
          ? read('fullName')
          : (read('name').isNotEmpty ? read('name') : read('userName')),
      avatar: read('avatar').isNotEmpty ? read('avatar') : read('avatarUrl'),
      subjects: subjects.toList(growable: false),
      classrooms: classrooms.toList(growable: false),
    );
  }

  final String id, name, avatar;
  final List<String> subjects, classrooms;
}
