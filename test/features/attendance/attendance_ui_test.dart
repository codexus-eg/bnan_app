import 'dart:async';

import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_lookup_models.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_cubit.dart';
import 'package:bnan_app/features/attendance/presentation/views/attendance_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_attendance_repo.dart';

void main() {
  testWidgets('API student reaches state and replaces the Arabic empty state', (
    tester,
  ) async {
    final repo = FakeAttendanceRepo()
      ..classrooms = const Right([
        AttendanceClassroom(
          id: 'c1',
          name: 'Class A',
          grade: AttendanceGrade(id: 'g1', name: 'First grade'),
        ),
      ])
      ..students = const Right([
        AttendanceStudent(id: '6a7d0a927733da367ed26f07', name: 'salmon'),
      ]);
    final cubit = AttendanceCubit(repo);
    addTearDown(cubit.close);
    await cubit.initialize(UserRole.supervisor);
    cubit.selectGrade('g1');
    final classroom = cubit.selectClassroom('c1');
    repo.pendingSessions['c1']!.complete(
      const Right([AttendanceSession(id: 'session-1', name: 'Math')]),
    );
    await classroom;
    await cubit.selectSession('session-1');

    expect(cubit.state.students, hasLength(1));
    await tester.pumpWidget(_testApp(cubit, const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('salmon'), findsOneWidget);
    expect(find.text('لا يوجد طلاب في هذا الفصل'), findsNothing);
  });

  testWidgets('submit button is disabled and loading during bulk request', (
    tester,
  ) async {
    final repo = FakeAttendanceRepo()
      ..classrooms = const Right([
        AttendanceClassroom(
          id: 'c1',
          name: 'Class A',
          grade: AttendanceGrade(id: 'g1', name: 'First grade'),
        ),
      ])
      ..students = const Right([AttendanceStudent(id: 's1', name: 'Sara')]);
    final cubit = AttendanceCubit(repo);
    await cubit.initialize(UserRole.teacher);
    cubit.selectGrade('g1');
    final classroom = cubit.selectClassroom('c1');
    repo.pendingSessions['c1']!.complete(
      const Right([AttendanceSession(id: 'session-1', name: 'Math')]),
    );
    await classroom;
    await cubit.selectSession('session-1');
    repo.submitCompleter = Completer();

    await tester.pumpWidget(_testApp(cubit, const Locale('en')));
    cubit.submit();
    await tester.pump();

    final button = tester.widget<CustomAppButton>(find.byType(CustomAppButton));
    expect(button.isLoading, isTrue);
    expect(button.onPressed, isNull);
    await cubit.close();
  });
}

Widget _testApp(AttendanceCubit cubit, Locale locale) => MaterialApp(
  locale: locale,
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: BlocProvider.value(value: cubit, child: const AttendanceView()),
);
