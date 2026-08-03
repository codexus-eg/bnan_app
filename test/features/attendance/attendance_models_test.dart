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
