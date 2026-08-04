import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_request_model.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/add_subject_dialog.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('grade follows curriculum and empty grades disable save', (
    tester,
  ) async {
    final lookupsRepo = _LookupsRepo();
    final lookups = _lookups(lookupsRepo);
    final subjects = _SubjectsRepo();
    await _pump(tester, lookups, subjects);

    final dropdowns = tester.widgetList<CustomDropdown>(
      find.byType(CustomDropdown),
    );
    expect(dropdowns.map((item) => item.label), ['Curriculum', 'Grade']);
    expect(dropdowns.last.hint, 'Choose a grade');

    await lookups.selectCurriculum(_firstCurriculum);
    await tester.pump();
    lookups.selectGrade(_grade);
    await tester.pump();
    expect(lookupsRepo.gradeScopes, ['curriculum-1']);
    expect(lookups.state.selectedGrade?.id, 'grade-1');

    await lookups.selectCurriculum(_emptyCurriculum);
    await tester.pump();
    expect(lookups.state.selectedGrade, isNull);
    expect(find.text('No grades are available for this curriculum'), findsOne);
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );
  });

  testWidgets('failure stays in dialog and success retry closes it', (
    tester,
  ) async {
    final lookups = _lookups(_LookupsRepo());
    final subjects = _SubjectsRepo(failFirst: true);
    await _pump(tester, lookups, subjects);
    await lookups.selectCurriculum(_firstCurriculum);
    lookups.selectGrade(_grade);
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), 'Arabic22');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('backend error'), findsOneWidget);
    expect(find.byType(AddSubjectDialog), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(subjects.request?.toJson(), {
      'name': 'Arabic22',
      'curriculum': 'curriculum-1',
      'grade': 'grade-1',
    });

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.byType(AddSubjectDialog), findsNothing);
  });

  testWidgets('grades failure is shown instead of the empty message', (
    tester,
  ) async {
    final lookups = _lookups(_LookupsRepo(failGrades: true));
    await _pump(tester, lookups, _SubjectsRepo());
    await lookups.selectCurriculum(_firstCurriculum);
    await tester.pump();

    expect(find.text('grades failed'), findsOneWidget);
    expect(
      find.text('No grades are available for this curriculum'),
      findsNothing,
    );
  });

  testWidgets('success refreshes subjects once and shows success message', (
    tester,
  ) async {
    final lookupsRepo = _LookupsRepo();
    if (getIt.isRegistered<AcademicLookupsRepo>()) {
      await getIt.unregister<AcademicLookupsRepo>();
    }
    getIt.registerSingleton<AcademicLookupsRepo>(lookupsRepo);
    addTearDown(() async {
      if (getIt.isRegistered<AcademicLookupsRepo>()) {
        await getIt.unregister<AcademicLookupsRepo>();
      }
    });
    final subjects = _SubjectsRepo();
    final listCubit = GetSubjectsCubit(subjects);
    final actions = SubjectActionsCubit(subjects);
    addTearDown(listCubit.close);
    addTearDown(actions.close);

    await tester.pumpWidget(
      _LocalizedApp(
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: listCubit),
            BlocProvider.value(value: actions),
          ],
          child: const SubjectManagementBody(),
        ),
      ),
    );
    await tester.tap(find.text('Add Subject'));
    await tester.pumpAndSettle();
    final dialogContext = tester.element(find.byType(AddSubjectDialog));
    final lookups = dialogContext.read<AcademicLookupsCubit>();
    await lookups.selectCurriculum(_firstCurriculum);
    lookups.selectGrade(_grade);
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), 'Arabic22');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(subjects.getCalls, 1);
    expect(find.text('Subject added successfully'), findsOneWidget);
  });
}

AcademicLookupsCubit _lookups(AcademicLookupsRepo repo) => AcademicLookupsCubit(
  repo: repo,
  loadClassroomsOnGrade: false,
  loadSubjectsWithoutClassroom: false,
  loadSubjectsOnClassroom: false,
);

Future<void> _pump(
  WidgetTester tester,
  AcademicLookupsCubit lookups,
  SubjectsRepo subjects,
) async {
  addTearDown(lookups.close);
  final actions = SubjectActionsCubit(subjects);
  addTearDown(actions.close);
  await tester.pumpWidget(
    _LocalizedApp(
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: lookups),
          BlocProvider.value(value: actions),
        ],
        child: const Scaffold(body: AddSubjectDialog()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _LocalizedApp extends StatelessWidget {
  const _LocalizedApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: child,
    );
  }
}

class _LookupsRepo implements AcademicLookupsRepo {
  _LookupsRepo({this.failGrades = false});

  final bool failGrades;
  final gradeScopes = <String?>[];

  @override
  Future<Either<Failure, List<AcademicCurriculumModel>>>
  getCurriculums() async => const Right([_firstCurriculum, _emptyCurriculum]);

  @override
  Future<Either<Failure, List<AcademicGradeModel>>> getGrades({
    String? curriculumId,
  }) async {
    gradeScopes.add(curriculumId);
    if (failGrades) return Left(Failure(message: 'grades failed'));
    return Right(
      curriculumId == _firstCurriculum.id ? const [_grade] : const [],
    );
  }

  @override
  Future<Either<Failure, List<AcademicClassroomModel>>> getClassroomsByGrade({
    required String curriculumId,
    required String gradeId,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<AcademicSubjectModel>>> getSubjects({
    required String curriculumId,
    required String gradeId,
    String? classroomId,
  }) async => const Right([]);
}

class _SubjectsRepo implements SubjectsRepo {
  _SubjectsRepo({this.failFirst = false});
  final bool failFirst;
  int calls = 0;
  int getCalls = 0;
  AddSubjectRequestModel? request;

  @override
  Future<Either<Failure, Unit>> addSubject({
    required AddSubjectRequestModel request,
  }) async {
    calls++;
    this.request = request;
    if (failFirst && calls == 1) return Left(Failure(message: 'backend error'));
    return const Right(unit);
  }

  @override
  Future<Either<Failure, SubjectsResponseModel>> getSubjects({
    required int page,
    required int perPage,
  }) async {
    getCalls++;
    return const Right(
      SubjectsResponseModel(success: true, length: 0, data: []),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateSubject({
    required String subjectId,
    required UpdateSubjectRequestModel request,
  }) async => const Right(unit);
}

const _firstCurriculum = AcademicCurriculumModel(
  id: 'curriculum-1',
  name: 'Curriculum one',
);
const _emptyCurriculum = AcademicCurriculumModel(
  id: 'curriculum-2',
  name: 'Curriculum two',
);
const _grade = AcademicGradeModel(id: 'grade-1', name: 'Grade one');
