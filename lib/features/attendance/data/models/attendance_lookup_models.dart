class AttendanceGrade {
  const AttendanceGrade({required this.id, required this.name});
  final String id, name;
}

class AttendanceClassroom {
  const AttendanceClassroom({
    required this.id,
    required this.name,
    required this.grade,
    this.registrationMode = '',
  });
  final String id, name;
  final String registrationMode;
  final AttendanceGrade grade;

  factory AttendanceClassroom.fromJson(Map<String, dynamic> json) {
    final classroom = _map(json['classroom']) ?? json;
    final grade = _map(classroom['grade']) ?? _map(json['grade']) ?? const {};
    final id = _text(classroom['id'] ?? classroom['_id']);
    final name = _text(classroom['name']);
    return AttendanceClassroom(
      id: id,
      name: name,
      registrationMode: _text(classroom['registrationMode']),
      grade: AttendanceGrade(
        id: _text(grade['id'] ?? grade['_id']),
        name: _text(grade['name']),
      ),
    );
  }

  AttendanceClassroom withGrade(AttendanceGrade value) => AttendanceClassroom(
    id: id,
    name: name,
    grade: value,
    registrationMode: registrationMode,
  );
}

class AttendanceSession {
  const AttendanceSession({required this.id, required this.name});
  final String id, name;

  factory AttendanceSession.fromJson(Map<String, dynamic> json) {
    final subject = _map(json['subject']);
    return AttendanceSession(
      id: _text(json['id'] ?? json['_id']),
      name: _text(json['name'] ?? json['title'] ?? subject?['name']),
    );
  }
}

class AttendanceStudent {
  const AttendanceStudent({required this.id, required this.name});
  final String id, name;

  factory AttendanceStudent.fromJson(Map<String, dynamic> json) {
    final student = _map(json['student']) ?? _map(json['user']) ?? json;
    return AttendanceStudent(
      id: _text(student['studentId'] ?? student['id'] ?? student['_id']),
      name: _text(student['fullName'] ?? student['name']),
    );
  }
}

Map<String, dynamic>? _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;
String _text(Object? value) => value?.toString().trim() ?? '';
