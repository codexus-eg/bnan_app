import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:bnan_app/features/student_subjects/data/repo/student_subjects_repo.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/student_subjects/presentation/student_subjects_filter.dart';
import 'package:bnan_app/features/student_subjects/presentation/views/student_subjects_view.dart';
import 'package:bnan_app/features/student_subjects/presentation/views/widgets/student_subject_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('search filters only by subject name', () {
    const subjects = [
      StudentSubjectModel(id: 'one', name: 'English'),
      StudentSubjectModel(id: 'two', name: 'Math'),
    ];

    expect(filterStudentSubjects(subjects, 'math'), [subjects.last]);
    expect(filterStudentSubjects(subjects, 'teacher'), isEmpty);
  });

  testWidgets('renders API names without a fake teacher and loads once', (
    tester,
  ) async {
    await getIt.reset();
    addTearDown(getIt.reset);
    final repo = _FakeRepo();
    getIt.registerFactory<GetMySubjectsCubit>(() => GetMySubjectsCubit(repo));

    await _pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Math'), findsOneWidget);
    expect(find.textContaining('Teacher'), findsNothing);
    expect(repo.calls, 1);

    await tester.enterText(find.byType(TextFormField), 'Math');
    await tester.pump();
    expect(find.text('English'), findsNothing);
    expect(
      find.descendant(
        of: find.byType(StudentSubjectCard),
        matching: find.text('Math'),
      ),
      findsOneWidget,
    );

    await _pumpView(tester);
    await tester.pumpAndSettle();
    expect(repo.calls, 1);
  });
}

Future<void> _pumpView(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const StudentSubjectsView(),
    ),
  );
}

class _FakeRepo implements StudentSubjectsRepo {
  int calls = 0;

  @override
  Future<Either<Failure, List<StudentSubjectModel>>> getMySubjects() async {
    calls++;
    return const Right([
      StudentSubjectModel(id: 'one', name: 'English'),
      StudentSubjectModel(id: 'two', name: 'Math'),
    ]);
  }
}
