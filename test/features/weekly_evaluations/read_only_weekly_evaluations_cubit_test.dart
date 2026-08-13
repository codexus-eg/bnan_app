import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_availability_status.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_mode.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/gulf_evaluation_classroom_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/parent_evaluation_child_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';

void main() {
  group('student', () {
    test('initial load omits week and student id', () async {
      final repo = _FakeReadRepo(response: _gulf(week: 4));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      expect(repo.calls.single, (week: null, studentId: null));
      expect(cubit.state.role, ReadOnlyEvaluationsRole.student);
      expect(cubit.state.selectedWeek, 4);
      expect(cubit.state.maxAvailableWeek, 4);
    });

    test('selected initial week is sent without student id', () async {
      final repo = _FakeReadRepo(response: _gulf(week: 3));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent(week: 3);
      expect(repo.calls.single, (week: 3, studentId: null));
    });

    test('response week replaces requested week', () async {
      final repo = _FakeReadRepo(response: _gulf(week: 6));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent(week: 5);
      expect(cubit.state.selectedWeek, 6);
      expect(cubit.state.maxAvailableWeek, 6);
    });

    test('gulf response with 70 classrooms succeeds', () async {
      final repo = _FakeReadRepo(response: _gulf(count: 70));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      expect(cubit.state.status, ReadOnlyEvaluationsStatus.success);
      expect(cubit.state.data?.classrooms, hasLength(70));
      expect(repo.calls, hasLength(1));
    });

    for (final status in [
      EvaluationAvailabilityStatus.notEvaluated,
      EvaluationAvailabilityStatus.notAvailable,
    ]) {
      test('gulf $status classrooms are not empty', () async {
        final repo = _FakeReadRepo(response: _gulf(status: status));
        final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
        await cubit.loadForStudent();
        expect(cubit.state.status, ReadOnlyEvaluationsStatus.success);
      });
    }

    test('egyptian subjects succeed even when not evaluated', () async {
      final repo = _FakeReadRepo(response: _egyptian());
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      expect(cubit.state.status, ReadOnlyEvaluationsStatus.success);
    });

    test('empty gulf classrooms emit empty', () async {
      final repo = _FakeReadRepo(response: _gulf(count: 0));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      expect(cubit.state.status, ReadOnlyEvaluationsStatus.empty);
    });

    test('empty egyptian subjects emit empty', () async {
      final repo = _FakeReadRepo(response: _egyptian(empty: true));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      expect(cubit.state.status, ReadOnlyEvaluationsStatus.empty);
    });

    test('unknown mode uses both collections as fallback', () async {
      final repo = _FakeReadRepo(response: _unknownWithSubject());
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      expect(cubit.state.status, ReadOnlyEvaluationsStatus.success);
    });
  });

  group('parent', () {
    test('no children emits empty without evaluations request', () async {
      final repo = _FakeReadRepo(children: const []);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      expect(repo.calls, isEmpty);
      expect(cubit.state.status, ReadOnlyEvaluationsStatus.empty);
      expect(cubit.state.hasLoadedChildren, isTrue);
    });

    test('one child is selected and its id is omitted', () async {
      final repo = _FakeReadRepo(children: const [_child1]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      expect(cubit.state.selectedChildId, 'child-1');
      expect(repo.calls.single.studentId, isNull);
    });

    test('multiple children select first and send its id', () async {
      final repo = _FakeReadRepo(children: const [_child1, _child2]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      expect(cubit.state.selectedChildId, 'child-1');
      expect(repo.calls.single.studentId, 'child-1');
    });

    test('gulf child without classroom emits empty without request', () async {
      const child = ParentEvaluationChildModel(
        id: 'gulf-child',
        registrationMode: RegistrationMode.gulf,
      );
      final repo = _FakeReadRepo(children: const [child]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);

      await cubit.loadForParent();

      expect(repo.calls, isEmpty);
      expect(cubit.state.status, ReadOnlyEvaluationsStatus.empty);
      expect(cubit.state.hasNoClassroom, isTrue);
    });

    test('selectChild resets max week from the new child response', () async {
      final repo = _FakeReadRepo(
        children: const [_child1, _child2],
        response: _gulf(week: 5),
      );
      repo.handler = (week, studentId) =>
          Future.value(Right(_gulf(week: studentId == 'child-2' ? 2 : 5)));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      await cubit.selectChild('child-2');
      expect(repo.calls.last, (week: null, studentId: 'child-2'));
      expect(cubit.state.selectedWeek, 2);
      expect(cubit.state.maxAvailableWeek, 2);
      expect(cubit.state.children, hasLength(2));
    });

    test('selectChild ignores blank, unknown, and current child', () async {
      final repo = _FakeReadRepo(children: const [_child1, _child2]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      await cubit.selectChild('');
      await cubit.selectChild('missing');
      await cubit.selectChild('child-1');
      expect(repo.calls, hasLength(1));
    });

    test('one-child parent week request omits student id', () async {
      final repo = _FakeReadRepo(children: const [_child1]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      await cubit.selectWeek(2);
      expect(repo.calls.last, (week: 2, studentId: null));
    });

    test('multi-child parent week request sends selected child', () async {
      final repo = _FakeReadRepo(children: const [_child1, _child2]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      await cubit.selectChild('child-2');
      await cubit.selectWeek(2);
      expect(repo.calls.last, (week: 2, studentId: 'child-2'));
    });
  });

  group('selection and failures', () {
    test('student selectWeek sends week and no student id', () async {
      final repo = _FakeReadRepo();
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      await cubit.selectWeek(2);
      expect(repo.calls.last, (week: 2, studentId: null));
    });

    test('invalid and duplicate weeks do not request', () async {
      final repo = _FakeReadRepo(response: _gulf(week: 2));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      await cubit.selectWeek(0);
      await cubit.selectWeek(2);
      expect(repo.calls, hasLength(1));
    });

    test(
      'older week does not shrink max and newer week remains selectable',
      () async {
        final repo = _FakeReadRepo(response: _gulf(week: 2));
        final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
        await cubit.loadForStudent();
        repo.handler = (week, _) => Future.value(Right(_gulf(week: week ?? 2)));

        await cubit.selectWeek(1);
        expect(cubit.state.selectedWeek, 1);
        expect(cubit.state.maxAvailableWeek, 2);

        await cubit.selectWeek(2);
        expect(cubit.state.selectedWeek, 2);
        expect(cubit.state.maxAvailableWeek, 2);
      },
    );

    for (final message in ['Access denied', 'Gulf evaluation conflict']) {
      test('repository failure preserves exact message: $message', () async {
        final repo = _FakeReadRepo(failure: Failure(message: message));
        final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
        await cubit.loadForStudent();
        expect(cubit.state.status, ReadOnlyEvaluationsStatus.failure);
        expect(cubit.state.failureMessage, message);
      });
    }

    test('refresh failure preserves last successful data', () async {
      final repo = _FakeReadRepo(response: _gulf(week: 1));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      final previous = cubit.state.data;
      repo.failure = Failure(message: 'Refresh failed');
      await cubit.selectWeek(2);
      expect(cubit.state.data, same(previous));
      expect(cubit.state.failureMessage, 'Refresh failed');
    });

    test('retry reloads current parent child and week', () async {
      final repo = _FakeReadRepo(
        children: const [_child1, _child2],
        response: _gulf(week: 4),
      );
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      repo.failure = Failure(message: 'Refresh failed');
      await cubit.selectWeek(3);
      repo.failure = null;
      await cubit.retry();
      expect(repo.calls.last, (week: 3, studentId: 'child-1'));
      expect(cubit.state.status, ReadOnlyEvaluationsStatus.success);
    });

    test('older response cannot replace a newer response', () async {
      final repo = _FakeReadRepo(response: _gulf(week: 1));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      final older =
          Completer<Either<Failure, MeWeeklyEvaluationsResponseModel>>();
      final newer =
          Completer<Either<Failure, MeWeeklyEvaluationsResponseModel>>();
      repo.handler = (week, _) => week == 2 ? older.future : newer.future;
      final olderCall = cubit.selectWeek(2);
      final newerCall = cubit.selectWeek(3);
      newer.complete(Right(_gulf(week: 3)));
      await newerCall;
      older.complete(Right(_gulf(week: 2)));
      await olderCall;
      expect(cubit.state.selectedWeek, 3);
      expect(cubit.state.data?.week, 3);
    });
  });
}

const _child1 = ParentEvaluationChildModel(id: 'child-1', fullName: 'One');
const _child2 = ParentEvaluationChildModel(id: 'child-2', fullName: 'Two');

MeWeeklyEvaluationsResponseModel _gulf({
  int count = 1,
  int week = 1,
  EvaluationAvailabilityStatus status = EvaluationAvailabilityStatus.evaluated,
}) => MeWeeklyEvaluationsResponseModel(
  success: true,
  data: MeWeeklyEvaluationsDataModel(
    mode: EvaluationMode.gulf,
    week: week,
    classrooms: List.generate(
      count,
      (index) => GulfEvaluationClassroomModel(
        id: 'class-$index',
        evaluationStatus: status,
      ),
    ),
  ),
);

MeWeeklyEvaluationsResponseModel _egyptian({bool empty = false}) =>
    MeWeeklyEvaluationsResponseModel(
      success: true,
      data: MeWeeklyEvaluationsDataModel(
        mode: EvaluationMode.egyptian,
        week: 1,
        subjects: empty
            ? const []
            : const [MeEvaluationSubjectModel(id: 'subject-1')],
      ),
    );

MeWeeklyEvaluationsResponseModel _unknownWithSubject() =>
    const MeWeeklyEvaluationsResponseModel(
      success: true,
      data: MeWeeklyEvaluationsDataModel(
        subjects: [MeEvaluationSubjectModel(id: 'subject-1')],
      ),
    );

class _FakeReadRepo implements WeeklyEvaluationsReadRepo {
  _FakeReadRepo({
    this.children = const [_child1],
    MeWeeklyEvaluationsResponseModel? response,
    this.failure,
  }) : response = response ?? _gulf();

  final List<ParentEvaluationChildModel> children;
  final MeWeeklyEvaluationsResponseModel response;
  Failure? failure;
  Future<Either<Failure, MeWeeklyEvaluationsResponseModel>> Function(
    int?,
    String?,
  )?
  handler;
  final calls = <({int? week, String? studentId})>[];

  @override
  Future<Either<Failure, List<ParentEvaluationChildModel>>>
  getParentChildren() async => Right(children);

  @override
  Future<Either<Failure, MeWeeklyEvaluationsResponseModel>> getMyEvaluations({
    int? week,
    String? studentId,
  }) {
    calls.add((week: week, studentId: studentId));
    final callback = handler;
    if (callback != null) return callback(week, studentId);
    final currentFailure = failure;
    return Future.value(
      currentFailure == null ? Right(response) : Left(currentFailure),
    );
  }
}
