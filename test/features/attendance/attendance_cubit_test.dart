import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_lookup_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_status.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_attendance_repo.dart';

void main() {
  late FakeAttendanceRepo repo;
  late AttendanceCubit cubit;
  const students = [
    AttendanceStudent(id: 's1', name: 'Sara'),
    AttendanceStudent(id: 's2', name: 'Ali'),
  ];

  setUp(() {
    repo = FakeAttendanceRepo()..students = const Right(students);
    cubit = AttendanceCubit(repo);
  });
  tearDown(() => cubit.close());

  Future<void> ready() async {
    final classroomFuture = cubit.selectClassroom('c1');
    repo.pendingSessions['c1']!.complete(
      const Right([AttendanceSession(id: 'session-1', name: 'Math')]),
    );
    await classroomFuture;
    await cubit.selectSession('session-1');
  }

  test(
    'students default to present and one update does not change others',
    () async {
      await ready();
      expect(
        cubit.state.statusByStudentId.values,
        everyElement(AttendanceStatus.present),
      );
      cubit.updateStatus('s1', AttendanceStatus.absent);
      expect(cubit.state.statusByStudentId['s1'], AttendanceStatus.absent);
      expect(cubit.state.statusByStudentId['s2'], AttendanceStatus.present);
    },
  );

  test('does not submit without session or students', () async {
    expect(await cubit.submit(), isFalse);
    expect(repo.submitted, isNull);
  });

  test('submits actual session id and failure preserves statuses', () async {
    await ready();
    cubit.updateStatus('s1', AttendanceStatus.late);
    repo.submitResult = Left(Failure(message: 'backend message'));
    expect(await cubit.submit(), isFalse);
    expect(repo.submitted!.sessionId, 'session-1');
    expect(cubit.state.statusByStudentId['s1'], AttendanceStatus.late);
  });

  test('changing classroom clears session and students', () async {
    await ready();
    cubit.selectClassroom('c2');
    expect(cubit.state.selectedSessionId, isNull);
    expect(cubit.state.students, isEmpty);
  });

  test('stale classroom sessions response is ignored', () async {
    final old = cubit.selectClassroom('old');
    final current = cubit.selectClassroom('new');
    repo.pendingSessions['new']!.complete(
      const Right([AttendanceSession(id: 'new-session', name: 'New')]),
    );
    await current;
    repo.pendingSessions['old']!.complete(
      const Right([AttendanceSession(id: 'old-session', name: 'Old')]),
    );
    await old;
    expect(cubit.state.sessions.single.id, 'new-session');
  });

  test('rapid session change ignores the old students response', () async {
    final classroom = cubit.selectClassroom('c1');
    repo.pendingSessions['c1']!.complete(
      const Right([AttendanceSession(id: 'old', name: 'Old')]),
    );
    await classroom;
    repo.deferStudents = true;
    final old = cubit.selectSession('old');
    final current = cubit.selectSession('new');
    repo.pendingStudents[1].complete(
      const Right([AttendanceStudent(id: 'new-student', name: 'New')]),
    );
    await current;
    repo.pendingStudents[0].complete(
      const Right([AttendanceStudent(id: 'old-student', name: 'Old')]),
    );
    await old;
    expect(cubit.state.students.single.id, 'new-student');
  });
}
