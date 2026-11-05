import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo_impl.dart';
import 'package:bnan_app/features/lessons_management/domain/models/schedule_sync_event.dart';
import 'package:bnan_app/features/lessons_management/domain/schedule_notification_matcher.dart';
import 'package:bnan_app/features/lessons_management/domain/schedule_sync_coordinator.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/digital_schedule_grid_data.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/gulf_schedule_grid_adapter.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bnan_app/generated/l10n.dart';

import '../lessons_management/fake_gulf_schedule_repo.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
    await SessionManager.instance.saveSession(
      accessToken: 'test-token',
      refreshToken: '',
      userRole: 'student',
    );
  });

  group('ScheduleNotificationMatcher', () {
    test('matches standard and custom schedule notification keys', () {
      final keys = [
        'CLASSROOM_SCHEDULE_SET',
        'CLASSROOM_SCHEDULE_CREATED',
        'SCHEDULE_SET',
        'SCHEDULE_UPDATED',
        'CLASSROOM_SCHEDULE_UPDATED',
        'CLASS_SCHEDULE_UPDATED',
        'GULF_SCHEDULE_SET',
        'EGYPTIAN_SCHEDULE_SET',
        'STUDENT_SCHEDULE_SET',
        'STUDENT_SCHEDULE_ASSIGNED',
        'STUDENT_SCHEDULE_UPDATED',
        'CLASS_CANCELLED',
        'CLASS_RESCHEDULED',
        'CLASS_REMINDER',
        'CLASS_STARTED',
        'CLASS_ENDED',
      ];
      for (final key in keys) {
        final notif = _makeNotification(key: key);
        expect(ScheduleNotificationMatcher.isMatch(notif), isTrue,
            reason: 'Expected $key to match');
      }
    });

    test('matches keys containing SCHEDULE case-insensitively', () {
      final notif = _makeNotification(key: 'custom_schedule_event');
      expect(ScheduleNotificationMatcher.isMatch(notif), isTrue);
    });

    test('matches navigation screen or target referencing schedule', () {
      final notif1 = _makeNotification(screen: 'schedule');
      final notif2 = _makeNotification(screen: 'classroom_schedule');
      final notif3 = _makeNotification(target: 'classroom_schedules');
      expect(ScheduleNotificationMatcher.isMatch(notif1), isTrue);
      expect(ScheduleNotificationMatcher.isMatch(notif2), isTrue);
      expect(ScheduleNotificationMatcher.isMatch(notif3), isTrue);
    });

    test('matches Arabic schedule keywords in title or body', () {
      final notif = _makeNotification(
        key: 'CUSTOM_ALERT',
        title: 'تم تحديث جدول الفصل بنجاح',
      );
      expect(ScheduleNotificationMatcher.isMatch(notif), isTrue);
    });

    test('ignores unrelated notifications', () {
      final notif = _makeNotification(
        type: 'chat',
        key: 'CHAT_MESSAGE',
        title: 'رسالة جديدة',
        body: 'لديك رسالة في المحادثة',
      );
      expect(ScheduleNotificationMatcher.isMatch(notif), isFalse);
    });
  });

  group('ScheduleSyncCoordinator', () {
    test('debounces identical sync reasons within 600ms', () async {
      final repo = _TrackingGulfRepo();
      final coordinator = ScheduleSyncCoordinator(repo: repo);
      final events = <ScheduleSyncEvent>[];
      final sub = coordinator.syncStream.listen(events.add);

      coordinator.triggerSync(reason: 'CLASSROOM_SCHEDULE_SET');
      coordinator.triggerSync(reason: 'CLASSROOM_SCHEDULE_SET');
      coordinator.triggerSync(reason: 'CLASSROOM_SCHEDULE_SET');

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(events, hasLength(1));
      expect(repo.invalidateCalls, 1);

      await sub.cancel();
      coordinator.dispose();
    });

    test('fires sync on handleNotification for valid schedule notification',
        () async {
      final repo = _TrackingGulfRepo();
      final coordinator = ScheduleSyncCoordinator(repo: repo);
      final events = <ScheduleSyncEvent>[];
      final sub = coordinator.syncStream.listen(events.add);

      final notif = _makeNotification(
        key: 'CLASSROOM_SCHEDULE_SET',
        params: {'classroomId': 'class-123', 'studentId': 'student-456'},
      );
      coordinator.handleNotification(notif);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(events, hasLength(1));
      expect(events.first.reason, 'CLASSROOM_SCHEDULE_SET');
      expect(events.first.classroomId, 'class-123');
      expect(events.first.studentId, 'student-456');
      expect(repo.invalidateCalls, 1);

      await sub.cancel();
      coordinator.dispose();
    });

    test('ignores non-schedule notification in handleNotification', () async {
      final repo = _TrackingGulfRepo();
      final coordinator = ScheduleSyncCoordinator(repo: repo);
      final events = <ScheduleSyncEvent>[];
      final sub = coordinator.syncStream.listen(events.add);

      final notif = _makeNotification(type: 'homework', key: 'NEW_HOMEWORK');
      coordinator.handleNotification(notif);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(events, isEmpty);
      expect(repo.invalidateCalls, 0);

      await sub.cancel();
      coordinator.dispose();
    });

    test(
        'two different schedule notifications arriving close together are not suppressed',
        () async {
      final repo = _TrackingGulfRepo();
      final coordinator = ScheduleSyncCoordinator(repo: repo);
      final events = <ScheduleSyncEvent>[];
      final sub = coordinator.syncStream.listen(events.add);

      coordinator.triggerSync(
        reason: 'CLASSROOM_SCHEDULE_SET',
        classroomId: 'class-1',
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      coordinator.triggerSync(
        reason: 'CLASS_RESCHEDULED',
        classroomId: 'class-2',
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(events, hasLength(2));
      expect(events[0].reason, 'CLASSROOM_SCHEDULE_SET');
      expect(events[0].classroomId, 'class-1');
      expect(events[1].reason, 'CLASS_RESCHEDULED');
      expect(events[1].classroomId, 'class-2');
      expect(repo.invalidateCalls, 2);

      await sub.cancel();
      coordinator.dispose();
    });
  });

  group('GulfScheduleRepoImpl cache invalidation & generation', () {
    test('invalidateScheduleCache clears cached schedule', () async {
      final api = _CountingApi();
      final repo = GulfScheduleRepoImpl(api);

      final first = await repo.getMyGulfSchedule();
      expect(first.isRight(), isTrue);
      expect(api.getCalls, 1);

      final second = await repo.getMyGulfSchedule();
      expect(second.isRight(), isTrue);
      expect(api.getCalls, 1); // Served from cache

      repo.invalidateScheduleCache();

      final third = await repo.getMyGulfSchedule();
      expect(third.isRight(), isTrue);
      expect(api.getCalls, 2); // Re-fetched after invalidation
    });

    test('stale in-flight response does not overwrite cache after invalidation',
        () async {
      final api = _DelayedApi();
      final repo = GulfScheduleRepoImpl(api);

      // Start slow request
      final firstFuture = repo.getMyGulfSchedule();
      expect(api.getCalls, 1);

      // Invalidate while in-flight
      repo.invalidateScheduleCache();

      // Finish slow request
      api.firstCompleter.complete(_emptyResponse);
      await firstFuture;

      // Next request must NOT use stale response from request 1
      api.secondCompleter = Completer<Object>();
      final secondFuture = repo.getMyGulfSchedule();
      expect(api.getCalls, 2);
      api.secondCompleter!.complete(_activeResponse);
      final result = await secondFuture;

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('should succeed'), (resp) {
        expect(resp.data.classrooms, hasLength(1));
      });
    });

    test(
        'switching accounts does not expose cached schedule from previous account',
        () async {
      final api = _AccountSwitchingApi();
      final repo = GulfScheduleRepoImpl(api);

      // Student A session
      await SessionManager.instance.saveSession(
        accessToken: 'token-student-a',
        refreshToken: '',
        userId: 'student-a',
        userRole: 'student',
      );

      final studentAResult = await repo.getMyGulfSchedule();
      expect(studentAResult.isRight(), isTrue);
      expect(api.getCalls, 1);
      studentAResult.fold((_) => fail('should succeed'), (resp) {
        expect(resp.data.classrooms.first.name, 'Student A Class');
      });

      // Second call for Student A hits cache
      final studentACached = await repo.getMyGulfSchedule();
      expect(studentACached.isRight(), isTrue);
      expect(api.getCalls, 1);

      // Switch to Student B session
      await SessionManager.instance.clearSession();
      await SessionManager.instance.saveSession(
        accessToken: 'token-student-b',
        refreshToken: '',
        userId: 'student-b',
        userRole: 'student',
      );

      // Call for Student B must NOT use Student A cache
      final studentBResult = await repo.getMyGulfSchedule();
      expect(studentBResult.isRight(), isTrue);
      expect(api.getCalls, 2);
      studentBResult.fold((_) => fail('should succeed'), (resp) {
        expect(resp.data.classrooms.first.name, 'Student B Class');
      });
    });
  });

  group('GulfScheduleCubit reactive synchronization', () {
    test('initially empty schedule cubit receives new data on refresh',
        () async {
      final repo = FakeGulfScheduleRepo(classrooms: []);
      final cubit = GulfScheduleCubit(repo);

      await cubit.load();
      expect(cubit.state.status, GulfScheduleLoadStatus.ready);
      expect(cubit.state.classrooms, isEmpty);

      // Backend assigns schedule
      repo.classrooms = [
        gulfClassroom(
          id: 'class-new',
          entries: const [
            GulfScheduleEntry(
              day: 'sunday',
              startTime: '10:00',
              endTime: '11:00',
            ),
          ],
        ),
      ];

      // Refresh invoked via schedule notification sync
      await cubit.refresh();

      expect(cubit.state.status, GulfScheduleLoadStatus.ready);
      expect(cubit.state.classrooms, hasLength(1));
      expect(cubit.state.selectedClassroomId, 'class-new');
      expect(cubit.state.selectedClassroom?.entries, hasLength(1));
      await cubit.close();
    });

    test(
        'scenarios 1-5: initially empty schedule updates automatically on notification with correct details',
        () async {
      final repo = FakeGulfScheduleRepo(classrooms: []);
      final coordinator = ScheduleSyncCoordinator(repo: repo);
      final cubit = GulfScheduleCubit(repo);

      final sub = coordinator.syncStream.listen((_) {
        unawaited(cubit.refresh());
      });

      // 1. Student has an initially empty schedule while app remains open
      await cubit.load();
      expect(cubit.state.status, GulfScheduleLoadStatus.ready);
      expect(cubit.state.classrooms, isEmpty);

      // 2. Authorized admin assigns a new schedule for that student
      repo.classrooms = [
        gulfClassroom(
          id: 'classroom-101',
          entries: const [
            GulfScheduleEntry(
              day: 'sunday',
              startTime: '10:00',
              endTime: '11:00',
            ),
          ],
        ),
      ];

      // 3. Student receives schedule notification without restarting the app
      final notif = _makeNotification(
        key: 'CLASSROOM_SCHEDULE_SET',
        params: {'classroomId': 'classroom-101'},
      );
      coordinator.handleNotification(notif);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // 4. Existing Schedule screen updates automatically
      expect(cubit.state.status, GulfScheduleLoadStatus.ready);
      expect(cubit.state.classrooms, hasLength(1));

      // 5. Newly assigned appointment appears with correct classroom, subject, day, and time
      final classroom = cubit.state.classrooms.first;
      expect(classroom.id, 'classroom-101');
      expect(classroom.name, 'Class A');
      expect(classroom.subject?.name, 'Math');
      expect(classroom.entries, hasLength(1));
      expect(classroom.entries.first.day, 'sunday');
      expect(classroom.entries.first.startTime, '10:00');
      expect(classroom.entries.first.endTime, '11:00');

      await sub.cancel();
      coordinator.dispose();
      await cubit.close();
    });

    test('preserves existing schedule and stays ready if refresh fails',
        () async {
      final repo = FakeGulfScheduleRepo(
        classrooms: [gulfClassroom(id: 'class-existing')],
      );
      final cubit = GulfScheduleCubit(repo);
      await cubit.load();
      expect(cubit.state.classrooms, hasLength(1));

      // Network fails during subsequent refresh
      repo.loadFailure = Failure(message: 'Network connection lost');
      await cubit.refresh();

      // Existing schedule data MUST be preserved, NOT cleared
      expect(cubit.state.status, GulfScheduleLoadStatus.ready);
      expect(cubit.state.classrooms, hasLength(1));
      expect(cubit.state.classrooms.first.id, 'class-existing');
      expect(cubit.state.loadError, 'Network connection lost');
      expect(cubit.state.isRefreshing, isFalse);
      await cubit.close();
    });

    test('generation tracking ignores delayed stale response', () async {
      final repo = FakeGulfScheduleRepo(classrooms: []);
      final cubit = GulfScheduleCubit(repo);

      final slowCompleter = Completer<void>();
      repo.loadGate = slowCompleter;

      // Start slow load
      final slowLoadFuture = cubit.load();

      // Faster sync refresh occurs
      repo.loadGate = null;
      repo.classrooms = [gulfClassroom(id: 'fresh-class')];
      await cubit.refresh();
      expect(cubit.state.classrooms.map((c) => c.id), contains('fresh-class'));

      // Slow load completes with older empty data
      repo.classrooms = [];
      slowCompleter.complete();
      await slowLoadFuture;

      // Newer fresh data remains intact
      expect(cubit.state.classrooms.map((c) => c.id), contains('fresh-class'));
      await cubit.close();
    });

    test('filters out Egyptian curriculum classrooms from Gulf cubit', () async {
      final repo = FakeGulfScheduleRepo(classrooms: [
        gulfClassroom(id: 'gulf-1'),
        GulfClassroom(
          id: 'egyptian-1',
          name: 'Egyptian Class',
          curriculum: const GulfCurriculum(
            id: 'curr-eg',
            name: 'Egyptian',
            registrationMode: 'egyptian',
          ),
        ),
      ]);
      final cubit = GulfScheduleCubit(repo);
      await cubit.load();

      expect(cubit.state.classrooms, hasLength(1));
      expect(cubit.state.classrooms.first.id, 'gulf-1');
      await cubit.close();
    });
  });

  group('DigitalScheduleContent UI rendering', () {
    testWidgets('shows loading indicator and never empty widget when loading',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DigitalScheduleContent(
              data: DigitalScheduleGridData(days: [], times: [], cells: {}),
              emptyMessage: 'لا يوجد جدول',
              loading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(NoDataWidget), findsNothing);
      expect(find.text('لا يوجد جدول'), findsNothing);
    });

    testWidgets('shows empty widget only when not loading and data is empty',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DigitalScheduleContent(
              data: DigitalScheduleGridData(days: [], times: [], cells: {}),
              emptyMessage: 'لا يوجد جدول',
              loading: false,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(NoDataWidget), findsOneWidget);
      expect(find.text('لا يوجد جدول'), findsOneWidget);
    });

    testWidgets(
        'scenarios 4-5 UI: displays newly assigned appointment with correct subject and classroom',
        (tester) async {
      final classroom = gulfClassroom(
        id: 'classroom-101',
        entries: const [
          GulfScheduleEntry(
            day: 'sunday',
            startTime: '10:00',
            endTime: '11:00',
          ),
        ],
      );
      final gridData = adaptGulfStudentSchedule(
        [classroom],
        studentSchedule: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: DigitalScheduleContent(
              data: gridData,
              emptyMessage: 'لا يوجد جدول',
              loading: false,
            ),
          ),
        ),
      );

      expect(find.byType(NoDataWidget), findsNothing);
      expect(find.text('Math\nClass A'), findsOneWidget);
      expect(find.text('الأحد'), findsOneWidget);
      expect(find.text('10:00 AM - 11:00 AM'), findsOneWidget);
    });
  });
}

AppNotification _makeNotification({
  String type = 'schedule',
  String key = 'CLASSROOM_SCHEDULE_SET',
  String? screen,
  String? target,
  Map<String, dynamic>? params,
  String title = 'تحديث الجدول',
  String body = 'تم تعيين جدول جديد',
}) {
  return AppNotification.fromJson({
    'id': 'notif-1',
    'type': type,
    'key': key,
    'title': title,
    'body': body,
    'navigation': {
      'screen': screen ?? '',
      'target': target ?? '',
      'params': params ?? <String, dynamic>{},
    },
    'data': <String, dynamic>{},
    'isRead': false,
    'createdAt': DateTime.now().toIso8601String(),
  });
}

class _TrackingGulfRepo extends FakeGulfScheduleRepo {
  int invalidateCalls = 0;

  @override
  void invalidateScheduleCache() {
    invalidateCalls++;
    super.invalidateScheduleCache();
  }
}

class _CountingApi implements ApiConsumer {
  int getCalls = 0;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    getCalls++;
    return _emptyResponse;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DelayedApi implements ApiConsumer {
  int getCalls = 0;
  final firstCompleter = Completer<Object>();
  Completer<Object>? secondCompleter;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) {
    getCalls++;
    if (getCalls == 1) return firstCompleter.future;
    return secondCompleter?.future ?? Future.value(_emptyResponse);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _emptyResponse = {
  'success': true,
  'data': {
    'students': [
      {'classrooms': <Object>[]},
    ],
  },
};

const _activeResponse = {
  'success': true,
  'data': {
    'students': [
      {
        'classrooms': [
          {
            '_id': 'class-active',
            'name': 'Active Classroom',
            'schedule': {
              '_id': 'sch-1',
              'classroomSubject': 'subj-1',
              'schedule': <Object>[],
            },
          },
        ],
      },
    ],
  },
};

class _AccountSwitchingApi implements ApiConsumer {
  int getCalls = 0;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    getCalls++;
    final token = SessionManager.instance.accessToken;
    final className =
        token == 'token-student-b' ? 'Student B Class' : 'Student A Class';
    return {
      'success': true,
      'data': {
        'students': [
          {
            'classrooms': [
              {
                '_id': 'class-$token',
                'name': className,
                'schedule': {
                  '_id': 'sch-$token',
                  'classroomSubject': 'subj-1',
                  'schedule': <Object>[],
                },
              },
            ],
          },
        ],
      },
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

