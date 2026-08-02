import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_plan_child_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/get_teacher_assigned_subjects_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assigned_subject_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assigned_subjects_data_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/elapsed_evaluation_weeks_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/upsert_evaluation_request_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/repo/weekly_evaluations_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('classroom loads weeks and current week evaluations', () async {
    final repo = _FakeRepo();
    final cubit = _cubit(repo);
    await cubit.initialize('teacher');
    await cubit.setClassrooms(const [PlanClassroomOption(id: 'c1', name: 'A')]);

    expect(cubit.availableWeeks, [1, 2]);
    expect(cubit.selectedWeek, 2);
    expect(repo.weeklyCalls, [('c1', 2)]);
    expect(cubit.state, isA<EvaluationsLoaded>());
  });

  test('changing week requests selected value and ignores duplicate', () async {
    final repo = _FakeRepo();
    final cubit = _cubit(repo);
    await cubit.initialize('supervisor');
    await cubit.setClassrooms(const [PlanClassroomOption(id: 'c1', name: 'A')]);
    await cubit.selectWeek(1);
    await cubit.selectWeek(1);

    expect(repo.weeklyCalls, [('c1', 2), ('c1', 1)]);
  });

  test('student never sends a studentId', () async {
    final repo = _FakeRepo();
    final cubit = _cubit(repo);
    await cubit.initialize('student');
    await cubit.setClassrooms(const [PlanClassroomOption(id: 'c1', name: 'A')]);
    expect(repo.myCalls.single, (2, null));
  });

  test(
    'one-child parent omits id and multiple-child parent sends it',
    () async {
      final oneRepo = _FakeRepo(children: const [_child1]);
      final one = _cubit(oneRepo);
      await one.initialize('parent');
      expect(oneRepo.myCalls.single, (2, null));

      final multiRepo = _FakeRepo(children: const [_child1, _child2]);
      final multi = _cubit(multiRepo);
      await multi.initialize('parent');
      expect(multiRepo.myCalls.single, (2, 'child-1'));
      await multi.selectChild('child-2');
      expect(multi.selectedClassroom?.id, 'c2');
      expect(multiRepo.myCalls.last, (2, 'child-2'));
    },
  );

  test('successful save reloads the same classroom and week', () async {
    final repo = _FakeRepo();
    final cubit = _cubit(repo);
    await cubit.initialize('teacher');
    await cubit.setClassrooms(const [PlanClassroomOption(id: 'c1', name: 'A')]);
    await cubit.selectWeek(1);
    await cubit.upsert(_request);

    expect(cubit.selectedClassroom?.id, 'c1');
    expect(cubit.selectedWeek, 1);
    expect(repo.weeklyCalls.last, ('c1', 1));
    expect(repo.saved.single.week, 1);
  });

  test('empty evaluations still load students and a single subject', () async {
    final repo = _FakeRepo(emptyWeekly: true);
    final cubit = _cubit(repo);
    await cubit.initialize('teacher');
    await cubit.setClassrooms(const [PlanClassroomOption(id: 'c1', name: 'A')]);

    expect(cubit.state, isA<EvaluationsEmpty>());
    await cubit.loadFormStudents('c1');
    expect(cubit.formStudents.single.id, 'lookup-student');
    await cubit.loadFormSubjects(
      classroomId: 'c1',
      studentId: 'lookup-student',
    );
    expect(cubit.formSubjects.single.id, 'only-subject');

    await cubit.selectWeek(1);
    expect(cubit.formStudents.single.id, 'lookup-student');
    expect(cubit.formSubjects.single.id, 'only-subject');
  });

  test('teacher subjects are intersected by subject ID', () async {
    final repo = _FakeRepo(
      subjects: const [
        EvaluationSubjectModel(id: 'arabic', name: 'Math'),
        EvaluationSubjectModel(id: 'math', name: 'Arabic'),
        EvaluationSubjectModel(id: 'science', name: 'Science'),
      ],
    );
    final assignments = _FakeAssignmentsRepo({'math', 'science'});
    final cubit = WeeklyEvaluationsCubit(repo, assignments);
    await cubit.initialize('teacher');

    await cubit.loadFormSubjects(classroomId: 'c1', studentId: 'student');

    expect(cubit.formSubjects.map((item) => item.id), ['math', 'science']);
    expect(assignments.classroomCalls, ['c1']);
  });

  test(
    'supervisor keeps all student subjects without teacher filtering',
    () async {
      final repo = _FakeRepo(
        subjects: const [
          EvaluationSubjectModel(id: 'arabic', name: 'Arabic'),
          EvaluationSubjectModel(id: 'math', name: 'Math'),
        ],
      );
      final assignments = _FakeAssignmentsRepo(const {});
      final cubit = WeeklyEvaluationsCubit(repo, assignments);
      await cubit.initialize('supervisor');

      await cubit.loadFormSubjects(classroomId: 'c1', studentId: 'student');

      expect(cubit.formSubjects.map((item) => item.id), ['arabic', 'math']);
      expect(assignments.classroomCalls, isEmpty);
    },
  );

  test(
    'teacher assignment failure clears subjects and exposes message',
    () async {
      final repo = _FakeRepo();
      final assignments = _FakeAssignmentsRepo(
        const {},
        failure: Failure(message: 'Assigned subjects failed'),
      );
      final cubit = WeeklyEvaluationsCubit(repo, assignments);
      await cubit.initialize('teacher');

      await cubit.loadFormSubjects(classroomId: 'c1', studentId: 'student');

      expect(cubit.formSubjects, isEmpty);
      expect(cubit.state, isA<EvaluationOptionsFailure>());
      expect(
        (cubit.state as EvaluationOptionsFailure).message,
        'Assigned subjects failed',
      );
    },
  );
}

WeeklyEvaluationsCubit _cubit(_FakeRepo repo) =>
    WeeklyEvaluationsCubit(repo, _FakeAssignmentsRepo({'only-subject'}));

const _child1 = ParentPlanChildModel(
  id: 'child-1',
  fullName: 'One',
  classroom: PlanClassroomModel(id: 'c1', name: 'A'),
);
const _child2 = ParentPlanChildModel(
  id: 'child-2',
  fullName: 'Two',
  classroom: PlanClassroomModel(id: 'c2', name: 'B'),
);
const _request = UpsertEvaluationRequestModel(
  student: 's',
  classroom: 'c1',
  subject: 'x',
  week: 1,
  attendance: 'present',
  participation: 'good',
  homework: 'good',
  behavior: 'good',
);

class _FakeRepo implements WeeklyEvaluationsRepo {
  _FakeRepo({
    this.children = const [],
    this.emptyWeekly = false,
    this.subjects = const [
      EvaluationSubjectModel(id: 'only-subject', name: 'Math'),
    ],
  });
  final List<ParentPlanChildModel> children;
  final bool emptyWeekly;
  final List<EvaluationSubjectModel> subjects;
  final weeklyCalls = <(String, int)>[];
  final myCalls = <(int, String?)>[];
  final saved = <UpsertEvaluationRequestModel>[];

  @override
  Future<Either<Failure, ElapsedEvaluationWeeksModel>> getElapsedWeeks(
    String classroomId,
  ) async => const Right(
    ElapsedEvaluationWeeksModel(
      success: true,
      data: ElapsedEvaluationWeeksData(weeksCount: 2, currentWeek: 2),
    ),
  );

  @override
  Future<Either<Failure, WeeklyEvaluationsResponseModel>> getClassroomWeekly({
    required String classroomId,
    required int week,
  }) async {
    weeklyCalls.add((classroomId, week));
    return Right(emptyWeekly ? _emptyResponse(week) : _response(week));
  }

  @override
  Future<Either<Failure, WeeklyEvaluationsResponseModel>> getMyEvaluations({
    required int week,
    String? studentId,
  }) async {
    myCalls.add((week, studentId));
    return Right(_response(week));
  }

  @override
  Future<Either<Failure, ParentChildrenResponseModel>>
  getParentChildren() async =>
      Right(ParentChildrenResponseModel(data: children));

  @override
  Future<Either<Failure, List<WeeklyEvaluationStudentModel>>>
  getClassroomStudents(String classroomId) async => const Right([
    WeeklyEvaluationStudentModel(
      id: 'lookup-student',
      fullName: 'Lookup Student',
    ),
  ]);

  @override
  Future<Either<Failure, List<EvaluationSubjectModel>>> getStudentSubjects({
    required String classroomId,
    required String studentId,
  }) async => Right(subjects);

  @override
  Future<Either<Failure, Unit>> upsert(
    UpsertEvaluationRequestModel request,
  ) async {
    saved.add(request);
    return const Right(unit);
  }
}

class _FakeAssignmentsRepo implements AssignmentsRepo {
  _FakeAssignmentsRepo(this.assignedIds, {this.failure});

  final Set<String> assignedIds;
  final Failure? failure;
  final classroomCalls = <String>[];

  @override
  Future<Either<Failure, GetTeacherAssignedSubjectsResponseModel>>
  getTeacherAssignedSubjects({required String classroomId}) async {
    classroomCalls.add(classroomId);
    if (failure case final failure?) return Left(failure);
    return Right(
      GetTeacherAssignedSubjectsResponseModel(
        success: true,
        results: assignedIds.length,
        data: TeacherAssignedSubjectsDataModel(
          classroom: null,
          subjects: assignedIds
              .map(
                (id) => TeacherAssignedSubjectModel(
                  classroomSubjectId: 'classroom-$id',
                  id: id,
                  name: id,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

WeeklyEvaluationsResponseModel _response(int week) =>
    WeeklyEvaluationsResponseModel.fromJson({
      'success': true,
      'data': {
        'week': week,
        'students': [
          {'id': 's', 'fullName': 'Student', 'subjects': <Object>[]},
        ],
      },
    });

WeeklyEvaluationsResponseModel _emptyResponse(int week) =>
    WeeklyEvaluationsResponseModel.fromJson({
      'success': true,
      'data': {'week': week, 'students': <Object>[]},
    });
