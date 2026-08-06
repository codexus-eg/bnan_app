import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/add_lesson_button.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lesson_card.dart';
import 'package:bnan_app/features/student_schedule/presentation/views/gulf_student_schedule_read_only_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lessons_management/fake_gulf_schedule_repo.dart';

void main() {
  late FakeGulfScheduleRepo repo;

  setUp(() {
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

  tearDown(() => getIt.reset());

  testWidgets('student Gulf schedule is functional read-only', (tester) async {
    await _pumpView(tester);

    final cubit = tester
        .element(find.byType(LessonCard))
        .read<GulfScheduleCubit>();
    expect(cubit.canManage, isFalse);
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

    repo.loadFailure = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(repo.loadCalls, 2);
  });

  testWidgets('empty classrooms and subject conflict are handled safely', (
    tester,
  ) async {
    repo.classrooms = const [];
    await _pumpView(tester);
    expect(find.text('No Gulf classrooms are available'), findsOneWidget);

    repo.classrooms = [
      GulfClassroom(id: 'class-1', name: 'Class A', hasSubjectConflict: true),
    ];
    await tester.pumpWidget(const SizedBox());
    await _pumpView(tester);
    expect(
      find.text(
        'The classroom subject data needs to be reviewed by the administration.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

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
