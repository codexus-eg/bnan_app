import 'dart:async';

import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lesson_card.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_body.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_week_days_selector.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/lessons_management_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_gulf_schedule_repo.dart';

void main() {
  testWidgets('shows loading then no classrooms state', (tester) async {
    final repo = FakeGulfScheduleRepo()..loadGate = Completer<void>();
    await _pump(tester, repo);
    expect(find.byType(AppSkeletonizer), findsOneWidget);
    repo.loadGate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('No Gulf classrooms are available'), findsOneWidget);
  });

  testWidgets('load failure shows backend message and retry', (tester) async {
    final repo = FakeGulfScheduleRepo()
      ..loadFailure = Failure(message: 'Schedule unavailable');
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    expect(find.text('Schedule unavailable'), findsOneWidget);
    repo.loadFailure = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('No Gulf classrooms are available'), findsOneWidget);
  });

  testWidgets('distinguishes no schedule from empty selected day', (
    tester,
  ) async {
    final noSchedule = FakeGulfScheduleRepo(
      classrooms: [gulfClassroom(withSchedule: false)],
    );
    await _pump(tester, noSchedule);
    await tester.pumpAndSettle();
    expect(
      find.text('No schedule entries have been added for this classroom yet'),
      findsOneWidget,
    );

    final scheduled = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          entries: const [GulfScheduleEntry(day: 'sunday', startTime: '18:00')],
        ),
      ],
    );
    await _pump(tester, scheduled);
    await tester.pumpAndSettle();
    expect(find.text('No lesson is scheduled for this day'), findsOneWidget);
  });

  testWidgets('shows start time and opens edit dialog', (tester) async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          entries: const [
            GulfScheduleEntry(day: 'saturday', startTime: '18:00'),
          ],
        ),
      ],
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    expect(find.text('18:00'), findsOneWidget);
    await tester.tap(find.text('18:00'));
    await tester.pumpAndSettle();
    expect(find.text('Edit schedule entry'), findsOneWidget);
  });

  testWidgets('edit dialog saves with PUT and closes on success', (
    tester,
  ) async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          entries: const [
            GulfScheduleEntry(day: 'saturday', startTime: '18:00'),
          ],
        ),
      ],
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    await tester.tap(find.text('18:00'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();
    expect(repo.lastOperation, 'put');
    expect(find.text('Edit schedule entry'), findsNothing);
  });

  testWidgets('deleting the final entry uses DELETE and refreshes UI', (
    tester,
  ) async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          entries: const [
            GulfScheduleEntry(day: 'saturday', startTime: '18:00'),
          ],
        ),
      ],
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    await tester.tap(find.text('18:00'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('deleteLessonIcon')), findsOneWidget);
    expect(find.text('Delete'), findsNothing);
    await tester.tap(find.byKey(const Key('deleteLessonIcon')));
    await tester.pumpAndSettle();
    expect(repo.lastOperation, 'delete');
    expect(find.text('Edit schedule entry'), findsNothing);
    expect(find.byType(LessonCard), findsNothing);
  });

  testWidgets('add dialog saves through repository and refreshes UI', (
    tester,
  ) async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [gulfClassroom(withSchedule: false)],
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Lesson'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('deleteLessonIcon')), findsNothing);
    await tester.tap(find.text('Start time').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add schedule entry'));
    await tester.pumpAndSettle();
    expect(repo.lastOperation, 'post');
    expect(find.byType(LessonCard), findsOneWidget);
  });

  testWidgets('save failure keeps add dialog open with backend message', (
    tester,
  ) async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [gulfClassroom(withSchedule: false)],
    )..saveFailure = Failure(message: 'Conflict');
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Lesson'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start time').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add schedule entry'));
    await tester.pumpAndSettle();
    expect(find.text('Add schedule entry'), findsOneWidget);
    expect(find.text('Conflict'), findsOneWidget);
  });

  testWidgets('Arabic RTL at 360px has no overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          entries: const [
            GulfScheduleEntry(day: 'saturday', startTime: '18:00'),
          ],
        ),
      ],
    );
    await _pump(tester, repo, locale: const Locale('ar'));
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.byType(Scaffold))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('changing day filters locally without another GET', (
    tester,
  ) async {
    final repo = FakeGulfScheduleRepo(classrooms: [gulfClassroom()]);
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    final calls = repo.loadCalls;
    tester
        .widget<LessonsWeekDaysSelector>(find.byType(LessonsWeekDaysSelector))
        .onSelected('friday');
    await tester.pumpAndSettle();
    expect(repo.loadCalls, calls);
  });

  testWidgets('screen contains only reference actions without session UI', (
    tester,
  ) async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          entries: const [
            GulfScheduleEntry(day: 'saturday', startTime: '18:00'),
          ],
        ),
      ],
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    expect(find.text('Add Lesson'), findsOneWidget);
    expect(find.byType(LessonCard), findsOneWidget);
    expect(find.text('Lesson history'), findsNothing);
    expect(
      find.text('There are no previous lessons for this classroom'),
      findsNothing,
    );
    expect(find.text('Start lesson'), findsNothing);
    expect(find.text('Open lesson link'), findsNothing);
  });

  testWidgets('view creates one cubit and loads once', (tester) async {
    if (getIt.isRegistered<GulfScheduleCubit>()) {
      await getIt.unregister<GulfScheduleCubit>();
    }
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          entries: const [
            GulfScheduleEntry(day: 'saturday', startTime: '18:00'),
          ],
        ),
      ],
    );
    getIt.registerFactory<GulfScheduleCubit>(() => GulfScheduleCubit(repo));
    addTearDown(() async {
      if (getIt.isRegistered<GulfScheduleCubit>()) {
        await getIt.unregister<GulfScheduleCubit>();
      }
    });

    await tester.pumpWidget(_localizedHome(const LessonsManagementView()));
    await tester.pumpAndSettle();
    expect(find.byType(BlocProvider<GulfScheduleCubit>), findsOneWidget);
    expect(repo.loadCalls, 1);
  });

  testWidgets('changing classroom updates the visible schedule locally', (
    tester,
  ) async {
    final repo = FakeGulfScheduleRepo(
      classrooms: [
        gulfClassroom(
          id: 'class-1',
          entries: const [
            GulfScheduleEntry(day: 'saturday', startTime: '18:00'),
          ],
        ),
        gulfClassroom(
          id: 'class-2',
          entries: const [
            GulfScheduleEntry(day: 'saturday', startTime: '19:00'),
          ],
        ),
      ],
    );
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    final calls = repo.loadCalls;
    tester.widget<CustomDropdown>(find.byType(CustomDropdown).first).onChanged!(
      'class-2',
    );
    await tester.pumpAndSettle();
    expect(find.text('19:00'), findsOneWidget);
    expect(find.text('18:00'), findsNothing);
    expect(repo.loadCalls, calls);
  });
}

Future<void> _pump(
  WidgetTester tester,
  FakeGulfScheduleRepo repo, {
  Locale locale = const Locale('en'),
}) async {
  final cubit = GulfScheduleCubit(repo);
  addTearDown(cubit.close);
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MultiBlocProvider(
        providers: [BlocProvider.value(value: cubit..load())],
        child: const Scaffold(body: LessonsManagementBody()),
      ),
    ),
  );
}

Widget _localizedHome(Widget home) => MaterialApp(
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: home,
);
