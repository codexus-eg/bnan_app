import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_plan_child_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/elapsed_evaluation_weeks_model.dart';
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
    final cubit = WeeklyEvaluationsCubit(repo);
    await cubit.initialize('teacher');
    await cubit.setClassrooms(const [PlanClassroomOption(id: 'c1', name: 'A')]);

    expect(cubit.availableWeeks, [1, 2]);
    expect(cubit.selectedWeek, 2);
    expect(repo.weeklyCalls, [('c1', 2)]);
    expect(cubit.state, isA<EvaluationsLoaded>());
  });

  test('changing week requests selected value and ignores duplicate', () async {
    final repo = _FakeRepo();
    final cubit = WeeklyEvaluationsCubit(repo);
    await cubit.initialize('supervisor');
    await cubit.setClassrooms(const [PlanClassroomOption(id: 'c1', name: 'A')]);
    await cubit.selectWeek(1);
    await cubit.selectWeek(1);

    expect(repo.weeklyCalls, [('c1', 2), ('c1', 1)]);
  });

  test('student never sends a studentId', () async {
    final repo = _FakeRepo();
    final cubit = WeeklyEvaluationsCubit(repo);
    await cubit.initialize('student');
    await cubit.setClassrooms(const [PlanClassroomOption(id: 'c1', name: 'A')]);
    expect(repo.myCalls.single, (2, null));
  });

  test(
    'one-child parent omits id and multiple-child parent sends it',
    () async {
      final oneRepo = _FakeRepo(children: const [_child1]);
      final one = WeeklyEvaluationsCubit(oneRepo);
      await one.initialize('parent');
      expect(oneRepo.myCalls.single, (2, null));

      final multiRepo = _FakeRepo(children: const [_child1, _child2]);
      final multi = WeeklyEvaluationsCubit(multiRepo);
      await multi.initialize('parent');
      expect(multiRepo.myCalls.single, (2, 'child-1'));
      await multi.selectChild('child-2');
      expect(multi.selectedClassroom?.id, 'c2');
      expect(multiRepo.myCalls.last, (2, 'child-2'));
    },
  );

  test('successful save reloads the same classroom and week', () async {
    final repo = _FakeRepo();
    final cubit = WeeklyEvaluationsCubit(repo);
    await cubit.initialize('teacher');
    await cubit.setClassrooms(const [PlanClassroomOption(id: 'c1', name: 'A')]);
    await cubit.selectWeek(1);
    await cubit.upsert(_request);

    expect(cubit.selectedClassroom?.id, 'c1');
    expect(cubit.selectedWeek, 1);
    expect(repo.weeklyCalls.last, ('c1', 1));
    expect(repo.saved.single.week, 1);
  });
}

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
  _FakeRepo({this.children = const []});
  final List<ParentPlanChildModel> children;
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
    return Right(_response(week));
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
  Future<Either<Failure, Unit>> upsert(
    UpsertEvaluationRequestModel request,
  ) async {
    saved.add(request);
    return const Right(unit);
  }
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
