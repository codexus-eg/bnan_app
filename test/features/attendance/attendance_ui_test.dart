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

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider.value(value: cubit, child: const AttendanceView()),
      ),
    );
    cubit.submit();
    await tester.pump();

    final button = tester.widget<CustomAppButton>(find.byType(CustomAppButton));
    expect(button.isLoading, isTrue);
    expect(button.onPressed, isNull);
    await cubit.close();
  });
}
