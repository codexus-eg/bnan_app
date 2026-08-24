import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/attendance/data/repo/attendance_repo.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/student_call_alert_action.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _AttendanceRepo repo;

  setUp(() {
    repo = _AttendanceRepo();
    getIt.registerSingleton<AttendanceRepo>(repo);
  });

  tearDown(() async => getIt.unregister<AttendanceRepo>());

  testWidgets('call is enabled immediately after a completed attempt', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.byIcon(Icons.call_outlined));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.call_outlined));
    await tester.pump();

    expect(repo.calls, 2);
  });

  testWidgets('only an in-flight request blocks another tap', (tester) async {
    repo.pending = Completer<Either<Failure, void>>();
    await tester.pumpWidget(_app());
    await tester.tap(find.byIcon(Icons.call_outlined));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(repo.calls, 1);
    repo.pending!.complete(const Right(null));
    await tester.pump();
  });
}

Widget _app() => MaterialApp(
  localizationsDelegates: [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: const Scaffold(body: StudentCallAlertAction(studentId: 'student-1')),
);

class _AttendanceRepo extends Fake implements AttendanceRepo {
  int calls = 0;
  Completer<Either<Failure, void>>? pending;

  @override
  Future<Either<Failure, void>> callStudent(String studentId) {
    calls++;
    return pending?.future ?? Future.value(const Right(null));
  }
}
