import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/add_lesson_button.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lesson_card.dart';
import 'package:bnan_app/features/student_schedule/presentation/views/gulf_student_schedule_read_only_view.dart';
import 'package:bnan_app/features/student_schedule/presentation/mock/gulf_student_schedule_mock.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lessons_management/fake_gulf_schedule_repo.dart';

void main() {
  late FakeGulfScheduleRepo repo;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await _saveSession('student', registrationMode: RegistrationMode.gulf);
    repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          entries: const [
            GulfScheduleEntry(day: 'saturday', startTime: '18:00'),
          ],
        ),
      ],
    );
    if (getIt.isRegistered<GulfScheduleRepo>()) {
      getIt.unregister<GulfScheduleRepo>();
    }
    getIt.registerSingleton<GulfScheduleRepo>(repo);
  });

  tearDown(() async {
    await SessionManager.instance.clearSession();
    await getIt.reset();
  });

  testWidgets('student Gulf schedule is functional read-only', (tester) async {
    await _pumpView(tester);

    final cubit = tester
        .element(find.byType(LessonCard))
        .read<GulfScheduleCubit>();
    expect(cubit.canManage, isFalse);
    expect(cubit.state.classrooms.single.id, 'class-1');
    expect(find.byType(AddLessonButton), findsNothing);
    expect(tester.widget<LessonCard>(find.byType(LessonCard)).onTap, isNull);

    expect(await cubit.saveEntry(day: 'monday', startTime: '09:00'), isFalse);
    expect(await cubit.deleteEntry('saturday'), isFalse);
    expect(repo.lastOperation, isNull);
  });

  testWidgets('load failure exposes a working retry', (tester) async {
    repo.loadFailure = Failure(message: 'load failed');
    await _pumpView(tester);
    expect(find.text('load failed'), findsOneWidget);
    expect(find.byType(LessonCard), findsNothing);

    repo.loadFailure = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(repo.loadCalls, 2);
  });

  testWidgets('empty Gulf student success uses temporary mock data', (
    tester,
  ) async {
    repo.classrooms = const [];
    await _pumpView(tester);

    expect(find.byType(LessonCard), findsOneWidget);
    expect(find.text('09:00'), findsOneWidget);
    final cubit = tester
        .element(find.byType(LessonCard))
        .read<GulfScheduleCubit>();
    expect(cubit.state.classrooms, hasLength(4));
    expect(
      cubit.state.classrooms.every((item) => item.id.startsWith('mock-')),
      isTrue,
    );
  });

  testWidgets('subject conflict is handled safely without mock', (
    tester,
  ) async {
    repo.classrooms = [
      GulfClassroom(id: 'class-1', name: 'Class A', hasSubjectConflict: true),
    ];
    await _pumpView(tester);
    expect(
      find.text(
        'The classroom subject data needs to be reviewed by the administration.',
      ),
      findsOneWidget,
    );
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

      expect(find.byType(LessonCard), findsNothing);
      expect(find.text('No Gulf classrooms are available'), findsOneWidget);
    });
  }

  testWidgets('Egyptian student never receives Gulf mock data', (tester) async {
    await _saveSession('student', registrationMode: RegistrationMode.egyptian);
    repo.classrooms = const [];

    await _pumpView(tester);

    expect(find.byType(LessonCard), findsNothing);
    expect(find.text('No Gulf classrooms are available'), findsOneWidget);
  });

  testWidgets('student without registration mode never receives mock', (
    tester,
  ) async {
    await _saveSession('student');
    repo.classrooms = const [];

    await _pumpView(tester);

    expect(find.byType(LessonCard), findsNothing);
    expect(find.text('No Gulf classrooms are available'), findsOneWidget);
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
    MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: GulfStudentScheduleReadOnlyView(),
    ),
  );
  await tester.pumpAndSettle();
}
