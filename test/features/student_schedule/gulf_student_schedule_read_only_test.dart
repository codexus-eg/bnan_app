import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/add_lesson_button.dart';
import 'package:bnan_app/features/notifications/data/models/notification_preferences.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/data/models/notifications_page.dart';
import 'package:bnan_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:bnan_app/features/notifications/domain/recent_notification_ids.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/views/gulf_student_schedule_read_only_view.dart';
import 'package:bnan_app/features/student_schedule/presentation/mock/gulf_student_schedule_mock.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/digital_schedule_grid/digital_schedule_grid.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lessons_management/fake_gulf_schedule_repo.dart';
import '../lessons_management/fake_start_session_repo.dart';

void main() {
  late FakeGulfScheduleRepo repo;
  late StartSessionCubit sessionCubit;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await _saveSession('student', registrationMode: RegistrationMode.gulf);
    repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          entries: const [
            GulfScheduleEntry(
              day: 'saturday',
              startTime: '18:00',
              endTime: '19:00',
            ),
          ],
        ),
      ],
    );
    if (getIt.isRegistered<GulfScheduleRepo>()) {
      getIt.unregister<GulfScheduleRepo>();
    }
    getIt.registerSingleton<GulfScheduleRepo>(repo);
    sessionCubit = StartSessionCubit(
      FakeStartSessionRepo(),
      repo,
      _TableRepo(),
    );
    getIt.registerSingleton<StartSessionCubit>(sessionCubit);
  });

  tearDown(() async {
    await SessionManager.instance.clearSession();
    await getIt.reset();
  });

  testWidgets('student Gulf schedule is functional read-only', (tester) async {
    await _pumpView(tester);

    final cubit = tester
        .element(find.byType(DigitalScheduleGrid))
        .read<GulfScheduleCubit>();
    expect(cubit.canManage, isFalse);
    expect(cubit.state.classrooms.single.id, 'class-1');
    expect(find.byType(AddLessonButton), findsNothing);

    expect(
      await cubit.saveEntry(
        day: 'monday',
        startTime: '09:00',
        endTime: '10:00',
      ),
      isFalse,
    );
    expect(await cubit.deleteEntry('saturday'), isFalse);
    expect(repo.lastOperation, isNull);
  });

  testWidgets('load failure exposes a working retry', (tester) async {
    repo.loadFailure = Failure(message: 'load failed');
    await _pumpView(tester);
    expect(find.text('load failed'), findsOneWidget);
    expect(find.byType(DigitalScheduleGrid), findsNothing);

    repo.loadFailure = null;
    await tester.tap(find.text('Retry'));
    await _pumpUntilLoaded(tester);
    expect(repo.loadCalls, 2);
  });

  testWidgets('empty Gulf student success shows an empty schedule', (
    tester,
  ) async {
    repo.classrooms = const [];
    await _pumpView(tester);

    expect(find.byType(DigitalScheduleGrid), findsNothing);
    expect(find.text('No schedule'), findsOneWidget);
  });

  testWidgets('subject conflict is handled safely as an empty schedule', (
    tester,
  ) async {
    repo.classrooms = [
      GulfClassroom(id: 'class-1', name: 'Class A', hasSubjectConflict: true),
    ];
    await _pumpView(tester);
    expect(find.text('No schedule'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final role in ['parent', 'teacher', 'supervisor']) {
    testWidgets('$role never receives Gulf student mock data', (tester) async {
      await _saveSession(
        role,
        registrationMode: role == 'supervisor' ? RegistrationMode.gulf : null,
        registrationModes: role == 'teacher'
            ? const [RegistrationMode.gulf]
            : const [],
      );
      repo.classrooms = const [];

      await _pumpView(tester);

      expect(find.byType(DigitalScheduleGrid), findsNothing);
      expect(find.text('No schedule'), findsOneWidget);
    });
  }

  testWidgets('Egyptian student never receives Gulf mock data', (tester) async {
    await _saveSession('student', registrationMode: RegistrationMode.egyptian);
    repo.classrooms = const [];

    await _pumpView(tester);

    expect(find.byType(DigitalScheduleGrid), findsNothing);
    expect(find.text('No schedule'), findsOneWidget);
  });

  testWidgets('student without registration mode never receives mock', (
    tester,
  ) async {
    await _saveSession('student');
    repo.classrooms = const [];

    await _pumpView(tester);

    expect(find.byType(DigitalScheduleGrid), findsNothing);
    expect(find.text('No schedule'), findsOneWidget);
  });

  test('mock schedule entries contain startTime without endTime', () {
    final entries = buildMockGulfStudentSchedule().expand(
      (classroom) => classroom.entries,
    );

    expect(entries, isNotEmpty);
    expect(
      entries.every((entry) => !entry.toJson().containsKey('endTime')),
      isTrue,
    );
  });
}

Future<void> _saveSession(
  String role, {
  RegistrationMode? registrationMode,
  List<RegistrationMode> registrationModes = const [],
}) => SessionManager.instance.saveSession(
  accessToken: 'token',
  refreshToken: 'refresh',
  userRole: role,
  registrationMode: registrationMode,
  registrationModes: registrationModes,
);

Future<void> _pumpView(WidgetTester tester) async {
  await tester.pumpWidget(
    BlocProvider(
      create: (_) => NotificationsCubit(
        _UnusedNotificationsRepo(),
        SocketService(),
        RecentNotificationIds(),
      ),
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: GulfStudentScheduleReadOnlyView(),
      ),
    ),
  );
  await _pumpUntilLoaded(tester);
}

Future<void> _pumpUntilLoaded(WidgetTester tester) async {
  for (var frame = 0; frame < 20; frame++) {
    await tester.pump(const Duration(milliseconds: 10));
    if (find.byType(CircularProgressIndicator).evaluate().isEmpty) return;
  }
  fail('Gulf schedule did not finish loading');
}

class _TableRepo implements TableManagementRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedNotificationsRepo implements NotificationsRepo {
  @override
  Future<Either<Failure, AppNotification>> getGlobalNotificationDetails(
    String broadcastId,
  ) => throw UnimplementedError();
  @override
  Future<Either<Failure, NotificationsPage>> getNotifications(
    int page,
    int limit,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences() =>
      throw UnimplementedError();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
