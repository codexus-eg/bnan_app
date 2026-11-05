import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_subjects_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classroom_error_mapper.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_subjects_cubit/classroom_subjects_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_subjects_cubit/classroom_subjects_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_subjects_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeClassroomSubjectsRepo implements ClassroomsRepo {
  ClassroomSubjectsResponseModel? subjectsResponse;
  Failure? addFailure;
  Failure? deleteFailure;
  int getSubjectsCalls = 0;
  int addCalls = 0;
  int deleteCalls = 0;
  String? lastAddedSubjectId;
  String? lastAddedTeacherId;
  String? lastDeletedSubjectId;

  @override
  Future<Either<Failure, ClassroomSubjectsResponseModel>> getClassroomSubjects(
    String classroomId,
  ) async {
    getSubjectsCalls++;
    return Right(subjectsResponse ?? const ClassroomSubjectsResponseModel());
  }

  @override
  Future<Either<Failure, void>> addClassroomSubject({
    required String classroomId,
    required String subjectId,
    String? teacherId,
  }) async {
    addCalls++;
    lastAddedSubjectId = subjectId;
    lastAddedTeacherId = teacherId;
    if (addFailure != null) return Left(addFailure!);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteClassroomSubject({
    required String classroomId,
    required String classroomSubjectId,
  }) async {
    deleteCalls++;
    lastDeletedSubjectId = classroomSubjectId;
    if (deleteFailure != null) return Left(deleteFailure!);
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    await S.load(const Locale('ar'));
  });

  group('ClassroomSubjectsResponseModel', () {
    test('parses classroomKind, subjects and eligibleSubjects with effectiveClassroomSubjectId', () {
      final json = {
        'status': 'success',
        'classroomKind': 'shared',
        'data': [
          {
            'id': 'cs_101',
            'classroomSubjectId': 'cs_real_101',
            'subject': {'id': 'sub_1', 'name': 'Arabic'},
            'teacher': {'id': 'teach_1', 'fullName': 'Mr. Ahmed'},
            'isActive': true,
          },
        ],
        'eligibleSubjects': [
          {'id': 'sub_1', 'name': 'Arabic', 'isAssigned': true},
          {'id': 'sub_2', 'name': 'Math', 'isAssigned': false},
        ],
      };

      final model = ClassroomSubjectsResponseModel.fromJson(json);
      expect(model.classroomKind, 'shared');
      expect(model.isShared, isTrue);
      expect(model.subjects.length, 1);
      final assigned = model.subjects.first;
      expect(assigned.effectiveClassroomSubjectId, 'cs_real_101');
      expect(assigned.name, 'Arabic');
      expect(assigned.teacherName, 'Mr. Ahmed');

      expect(model.eligibleSubjects.length, 2);
      expect(model.unassignedEligibleSubjects.length, 1);
      expect(model.unassignedEligibleSubjects.first.id, 'sub_2');
      expect(model.unassignedEligibleSubjects.first.name, 'Math');
    });
  });

  group('classroom_error_mapper error mappings', () {
    test('maps 409 CLASSROOM_SUBJECT_HAS_SCHEDULED_LESSONS to localized message', () {
      final failure = mapClassroomFailure(
        const AppException(
          'Cannot delete subject',
          statusCode: 409,
          code: 'CLASSROOM_SUBJECT_HAS_SCHEDULED_LESSONS',
        ),
      );
      expect(failure.statusCode, 409);
      expect(failure.code, 'CLASSROOM_SUBJECT_HAS_SCHEDULED_LESSONS');
      expect(failure.message, S.current.classroomSubjectHasScheduledLessons);
    });

    test('maps 400 SHARED_CLASSROOM_REQUIRES_TWO_TARGETS to localized message', () {
      final failure = mapClassroomFailure(
        const AppException(
          'Invalid targets',
          statusCode: 400,
          code: 'SHARED_CLASSROOM_REQUIRES_TWO_TARGETS',
        ),
      );
      expect(failure.statusCode, 400);
      expect(failure.message, S.current.sharedClassroomRequiresTwoTargets);
    });

    test('maps 409 SUBJECT_ALREADY_ASSIGNED_TO_CLASSROOM to localized message', () {
      final failure = mapClassroomFailure(
        const AppException(
          'Already assigned',
          statusCode: 409,
          code: 'SUBJECT_ALREADY_ASSIGNED_TO_CLASSROOM',
        ),
      );
      expect(failure.statusCode, 409);
      expect(failure.message, S.current.subjectAlreadyAssignedToClassroom);
    });
  });

  group('ClassroomSubjectsCubit', () {
    late _FakeClassroomSubjectsRepo repo;
    late ClassroomSubjectsCubit cubit;

    setUp(() {
      repo = _FakeClassroomSubjectsRepo();
      cubit = ClassroomSubjectsCubit(repo);
    });

    tearDown(() => cubit.close());

    test('loads subjects successfully', () async {
      repo.subjectsResponse = ClassroomSubjectsResponseModel.fromJson({
        'data': [
          {'id': 'cs_1', 'name': 'Science'},
        ],
      });

      await cubit.loadSubjects('room_1');
      expect(cubit.state, isA<ClassroomSubjectsLoaded>());
      final loaded = cubit.state as ClassroomSubjectsLoaded;
      expect(loaded.data.subjects.length, 1);
      expect(loaded.data.subjects.first.name, 'Science');
    });

    test('addSubject sends subject and reloads on success', () async {
      repo.subjectsResponse = ClassroomSubjectsResponseModel.fromJson({
        'data': [
          {'id': 'cs_1', 'name': 'Science'},
        ],
      });
      await cubit.loadSubjects('room_1');

      await cubit.addSubject(
        classroomId: 'room_1',
        subjectId: 'sub_math',
        teacherId: 'teach_10',
      );

      expect(repo.addCalls, 1);
      expect(repo.lastAddedSubjectId, 'sub_math');
      expect(repo.lastAddedTeacherId, 'teach_10');
      expect(repo.getSubjectsCalls, 2);
    });

    test('deleteSubject sends effectiveClassroomSubjectId and surfaces 409 failure message', () async {
      repo.subjectsResponse = ClassroomSubjectsResponseModel.fromJson({
        'data': [
          {'id': 'raw_id_1', 'classroomSubjectId': 'effective_cs_1', 'name': 'History'},
        ],
      });
      await cubit.loadSubjects('room_1');

      repo.deleteFailure = Failure(
        message: S.current.classroomSubjectHasScheduledLessons,
        statusCode: 409,
        code: 'CLASSROOM_SUBJECT_HAS_SCHEDULED_LESSONS',
      );

      await cubit.deleteSubject(
        classroomId: 'room_1',
        classroomSubjectId: 'effective_cs_1',
      );

      expect(repo.deleteCalls, 1);
      expect(repo.lastDeletedSubjectId, 'effective_cs_1');
      expect(cubit.state, isA<ClassroomSubjectsLoaded>());
      final loaded = cubit.state as ClassroomSubjectsLoaded;
      expect(loaded.isError, isTrue);
      expect(loaded.feedbackMessage, S.current.classroomSubjectHasScheduledLessons);
    });
  });

  group('ClassroomSubjectsDialog UI test', () {
    testWidgets('shows subjects and triggers delete confirmation flow', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);
      final repo = _FakeClassroomSubjectsRepo();
      repo.subjectsResponse = ClassroomSubjectsResponseModel.fromJson({
        'data': [
          {
            'id': 'sub_row_1',
            'classroomSubjectId': 'cs_effective_99',
            'name': 'اللغة العربية',
          },
        ],
        'eligibleSubjects': [
          {'id': 'el_1', 'name': 'الرياضيات', 'isAssigned': false},
        ],
      });

      final cubit = ClassroomSubjectsCubit(repo);
      await cubit.loadSubjects('room_123');

      final classroom = ClassroomModel(
        id: 'room_123',
        name: 'فصل التجربة',
        curriculum: const ClassroomLookupModel(id: 'c1', name: 'المنهج المصري'),
        grade: const ClassroomLookupModel(id: 'g1', name: 'الصف الأول'),
        teachers: const [],
        isActive: true,
        approvedStudentsCount: 5,
        assignedTeachersCount: 1,
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
            body: BlocProvider.value(
              value: cubit,
              child: ClassroomSubjectsDialog(classroomItem: classroom),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('اللغة العربية'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.textContaining('اللغة العربية'), findsWidgets);
      expect(find.text(S.current.delete), findsOneWidget);

      await tester.tap(find.text(S.current.delete));
      await tester.pumpAndSettle();

      expect(repo.deleteCalls, 1);
      expect(repo.lastDeletedSubjectId, 'cs_effective_99');
    });
  });
}
