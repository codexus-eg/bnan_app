import 'package:bnan_app/features/attendance/data/models/attendance_lookup_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('attendance status uses the API values', () {
    expect(AttendanceStatus.present.apiValue, 'present');
    expect(AttendanceStatus.absent.apiValue, 'absent');
    expect(AttendanceStatus.late.apiValue, 'late');
  });

  test('attendance record parses underscore ids', () {
    final record = AttendanceRecord.fromJson({
      '_id': 'attendance-1',
      'student': {'_id': 'student-1'},
      'status': 'late',
    });
    expect(record.id, 'attendance-1');
    expect(record.studentId, 'student-1');
    expect(record.status, AttendanceStatus.late);
  });

  test(
    'classroom roster student parses studentId and ignores null attendance',
    () {
      final student = AttendanceStudent.fromJson({
        'studentId': '6a7d0a927733da367ed26f07',
        'fullName': 'salmon',
        'attendance': null,
      });

      expect(student.id, '6a7d0a927733da367ed26f07');
      expect(student.name, 'salmon');
      expect(AttendanceStudent.fromJson({'id': 'legacy-id'}).id, 'legacy-id');
      expect(AttendanceStudent.fromJson({'_id': 'mongo-id'}).id, 'mongo-id');
    },
  );

  test('bulk request removes duplicate and empty student ids', () {
    final request = BulkAttendanceRequest(
      sessionId: 'session-1',
      students: const [
        AttendanceStudentInput(
          studentId: 'student-1',
          status: AttendanceStatus.present,
        ),
        AttendanceStudentInput(
          studentId: 'student-1',
          status: AttendanceStatus.late,
        ),
        AttendanceStudentInput(studentId: '', status: AttendanceStatus.absent),
      ],
    );
    expect(request.students, hasLength(1));
    expect(request.toJson()['sessionId'], 'session-1');
    expect(request.students.single.status, AttendanceStatus.late);
  });
}
