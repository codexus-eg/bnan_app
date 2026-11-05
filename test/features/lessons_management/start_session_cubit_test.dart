import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
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

  test('tuesday lesson on saturday is not marked due', () async {
    final gulfRepo = _FakeGulfScheduleRepo(
      const GulfSchedulesResponse(
        success: true,
        data: GulfSchedulesData(
          classrooms: [
            GulfClassroom(
              id: 'class-gulf',
              name: 'Gulf Group',
              chatRoomId: 'chat-gulf',
              schedule: GulfSchedule(
                id: 'sched-1',
                classroomSubject: 'cs-1',
                isActive: true,
                entries: [
                  GulfScheduleEntry(
                    id: 'entry-tuesday',
                    day: 'tuesday',
                    startTime: '06:24',
                    endTime: '07:25',
                    chatRoomId: 'chat-gulf',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    final cubit = StartSessionCubit(
      FakeStartSessionRepo(),
      gulfRepo,
      _UnusedTableManagementRepo(),
    );
    await cubit.loadScheduledLessons();
    final isTodayTuesday = DateTime.now().weekday == DateTime.tuesday;
    if (!isTodayTuesday) {
      expect(cubit.state.scheduledClassroomIds.contains('class-gulf'), isFalse);
      expect(cubit.state.scheduledChatRoomIds.contains('chat-gulf'), isFalse);
      expect(cubit.state.dueLessonsByClassroom.containsKey('class-gulf'), isFalse);
    }
    await cubit.close();
  });

  test('matching schedule entry inside window is marked due with full metadata', () async {
    final now = DateTime.now();
    final todayWeekday = ScheduleTimeUtils.weekdayName(now.weekday);
    final startHour = now.hour.toString().padLeft(2, '0');
    final startMin = now.minute.toString().padLeft(2, '0');
    final startTime = '$startHour:$startMin';

    final gulfRepo = _FakeGulfScheduleRepo(
      GulfSchedulesResponse(
        success: true,
        data: GulfSchedulesData(
          classrooms: [
            GulfClassroom(
              id: 'class-due',
              name: 'Gulf Group Due',
              chatRoomId: 'chat-due',
              schedule: GulfSchedule(
                id: 'sched-due',
                classroomSubject: 'cs-due',
                isActive: true,
                entries: [
                  GulfScheduleEntry(
                    id: 'entry-due-123',
                    day: todayWeekday,
                    startTime: startTime,
                    endTime: '23:59',
                    chatRoomId: 'chat-due',
                    classroomSubjectId: 'cs-due',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    final cubit = StartSessionCubit(
      FakeStartSessionRepo(),
      gulfRepo,
      _UnusedTableManagementRepo(),
    );
    await cubit.loadScheduledLessons();
    expect(cubit.state.scheduledClassroomIds.contains('class-due'), isTrue);
    expect(cubit.state.scheduledChatRoomIds.contains('chat-due'), isTrue);
    final due = cubit.state.dueLesson(classroomId: 'class-due');
    expect(due, isNotNull);
    expect(due!.lessonId, isNull);
    expect(due.isGulf, isTrue);
    expect(due.system, 'gulf');
    expect(due.chatRoomId, 'chat-due');
    expect(due.classroomSubjectId, 'cs-due');
    await cubit.close();
  });

  test('egyptian schedule entry matching today is marked due', () async {
    final now = DateTime.now();
    final todayIso = now.toIso8601String().split('T').first;
    final startHour = now.hour.toString().padLeft(2, '0');
    final startMin = now.minute.toString().padLeft(2, '0');
    final startTime = '$startHour:$startMin';

    final tableRepo = _FakeTableManagementRepo(
      EgyptianScheduleWeek(
        days: [
          EgyptianScheduleDay(
            date: todayIso,
            lessons: [
              EgyptianDigitalLesson(
                id: 'egypt-lesson-1',
                date: todayIso,
                startTime: startTime,
                endTime: '23:59',
                classroomId: 'class-egypt',
                classroomName: 'Egypt Class',
                subjectId: 'sub-egypt',
                subjectName: 'Arabic',
                classroomSubjectId: 'cs-egypt',
                chatRoomId: 'chat-egypt',
              ),
            ],
          ),
        ],
      ),
    );
    final cubit = StartSessionCubit(
      FakeStartSessionRepo(),
      _UnusedGulfScheduleRepo(),
      tableRepo,
    );
    await cubit.loadScheduledLessons();
    expect(cubit.state.scheduledClassroomIds.contains('class-egypt'), isTrue);
    expect(cubit.state.scheduledChatRoomIds.contains('chat-egypt'), isTrue);
    final due = cubit.state.dueLesson(roomId: 'chat-egypt');
    expect(due, isNotNull);
    expect(due!.lessonId, 'egypt-lesson-1');
    expect(due.isEgyptian, isTrue);
    expect(due.system, 'egyptian');
    expect(due.occurrenceDate, todayIso);
    await cubit.close();
  });

  test('cubit.start forwards system and correct lessonId to repo', () async {
    final repo = FakeStartSessionRepo();
    final cubit = _cubit(repo);

    // Gulf start
    await cubit.start(
      classroomId: 'class-gulf',
      subjectId: 'sub-gulf',
      occurrenceDate: '2026-10-24',
      system: 'gulf',
    );
    expect(repo.recordedStarts.last.system, 'gulf');
    expect(repo.recordedStarts.last.lessonId, isNull);

    // Egyptian start
    await cubit.start(
      classroomId: 'class-egypt',
      subjectId: 'sub-egypt',
      lessonId: 'egypt-lesson-1',
      occurrenceDate: '2026-10-24',
      system: 'egyptian',
    );
    expect(repo.recordedStarts.last.system, 'egyptian');
    expect(repo.recordedStarts.last.lessonId, 'egypt-lesson-1');
    await cubit.close();
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

class _FakeGulfScheduleRepo implements GulfScheduleRepo {
  _FakeGulfScheduleRepo(this.response);
  final GulfSchedulesResponse response;

  @override
  void invalidateScheduleCache() {}

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getMyGulfSchedule({
    String? studentId,
  }) async => Right(response);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedTableManagementRepo implements TableManagementRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeTableManagementRepo implements TableManagementRepo {
  _FakeTableManagementRepo(this.week);
  final EgyptianScheduleWeek week;

  @override
  Future<Either<Failure, EgyptianScheduleWeek>> getMyEgyptianDigitalSchedule() async =>
      Right(week);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
