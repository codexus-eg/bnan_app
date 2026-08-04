import 'attendance_status.dart';

class AttendanceStudentInput {
  const AttendanceStudentInput({required this.studentId, required this.status});
  final String studentId;
  final AttendanceStatus status;

  Map<String, dynamic> toJson() => {
    'studentId': studentId,
    'status': status.apiValue,
  };
}

class BulkAttendanceRequest {
  BulkAttendanceRequest({
    required this.sessionId,
    required Iterable<AttendanceStudentInput> students,
  }) : students = _unique(students);

  final String sessionId;
  final List<AttendanceStudentInput> students;

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'students': students.map((student) => student.toJson()).toList(),
  };

  static List<AttendanceStudentInput> _unique(
    Iterable<AttendanceStudentInput> values,
  ) {
    final result = <String, AttendanceStudentInput>{};
    for (final value in values) {
      final id = value.studentId.trim();
      if (id.isNotEmpty) result[id] = value;
    }
    return result.values.toList(growable: false);
  }
}

class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.status,
  });
  final String id, studentId;
  final AttendanceStatus status;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final student = json['student'];
    final studentMap = student is Map
        ? Map<String, dynamic>.from(student)
        : const <String, dynamic>{};
    return AttendanceRecord(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      studentId:
          (studentMap['id'] ?? studentMap['_id'] ?? student)?.toString() ?? '',
      status: AttendanceStatusApi.fromApi(json['status']),
    );
  }
}
