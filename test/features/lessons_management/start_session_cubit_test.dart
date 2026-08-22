import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_start_session_repo.dart';

void main() {
  test('success is keyed by classroom and stores session/link', () async {
    final repo = FakeStartSessionRepo()..defer = true;
    final cubit = _cubit(repo);
    final request = cubit.start(classroomId: 'class-1', subjectId: 'subject-1');
    expect(cubit.state.isLoading('class-1'), isTrue);
    expect(cubit.state.isLoading('class-2'), isFalse);
    repo.pending['class-1']!.complete(Right(startedSessionData('class-1')));
    expect(await request, isTrue);
    expect(cubit.state.started('class-1')?.session.id, 'session-class-1');
    expect(cubit.state.started('class-1')?.meetingLink, contains('zoom.us'));
    await cubit.close();
  });

  test('double submit for the same classroom sends one request', () async {
    final repo = FakeStartSessionRepo()..defer = true;
    final cubit = _cubit(repo);
    final first = cubit.start(classroomId: 'class-1', subjectId: 'subject-1');
    expect(
      await cubit.start(classroomId: 'class-1', subjectId: 'subject-1'),
      isFalse,
    );
    expect(repo.calls, hasLength(1));
    repo.pending['class-1']!.complete(Right(startedSessionData('class-1')));
    await first;
    await cubit.close();
  });

  test('two classrooms keep independent loading and results', () async {
    final repo = FakeStartSessionRepo()..defer = true;
    final cubit = _cubit(repo);
    final first = cubit.start(classroomId: 'class-1', subjectId: 'subject-1');
    final second = cubit.start(classroomId: 'class-2', subjectId: 'subject-2');
    repo.pending['class-2']!.complete(Right(startedSessionData('class-2')));
    await second;
    expect(cubit.state.isLoading('class-1'), isTrue);
    expect(cubit.state.started('class-2')?.session.id, 'session-class-2');
    repo.pending['class-1']!.complete(Right(startedSessionData('class-1')));
    await first;
    expect(cubit.state.startedByClassroom, hasLength(2));
    await cubit.close();
  });

  test('missing subject is rejected before API call', () async {
    final repo = FakeStartSessionRepo();
    final cubit = _cubit(repo);
    expect(await cubit.start(classroomId: 'class-1', subjectId: ''), isFalse);
    expect(cubit.state.eventIssue, StartSessionIssue.missingSubject);
    expect(repo.calls, isEmpty);
    await cubit.close();
  });

  test('API conflict clears loading and preserves backend key', () async {
    final repo = FakeStartSessionRepo()
      ..failure = Failure(message: 'CLASSROOM_SESSION_ALREADY_ACTIVE');
    final cubit = _cubit(repo);
    expect(
      await cubit.start(classroomId: 'class-1', subjectId: 'subject-1'),
      isFalse,
    );
    expect(cubit.state.isLoading('class-1'), isFalse);
    expect(cubit.state.eventError, 'CLASSROOM_SESSION_ALREADY_ACTIVE');
    await cubit.close();
  });

  test('response after cubit close is ignored safely', () async {
    final repo = FakeStartSessionRepo()..defer = true;
    final cubit = _cubit(repo);
    final request = cubit.start(classroomId: 'class-1', subjectId: 'subject-1');
    await cubit.close();
    repo.pending['class-1']!.complete(Right(startedSessionData('class-1')));
    expect(await request, isFalse);
  });
}

StartSessionCubit _cubit(StartSessionRepo repo) => StartSessionCubit(
  repo,
  _UnusedGulfScheduleRepo(),
  _UnusedTableManagementRepo(),
);

class _UnusedGulfScheduleRepo implements GulfScheduleRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedTableManagementRepo implements TableManagementRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
