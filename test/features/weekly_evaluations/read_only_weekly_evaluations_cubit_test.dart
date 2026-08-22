import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_availability_status.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_mode.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/gulf_evaluation_classroom_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/parent_evaluation_child_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('student', () {
    test('initial load omits week and student id', () async {
      final repo = _FakeReadRepo(response: _gulf(week: 4));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      expect(repo.calls.single, (
        week: null,
        studentId: null,
        classroomId: 'general',
      ));
      expect(cubit.state.role, ReadOnlyEvaluationsRole.student);
      expect(cubit.state.selectedWeek, 4);
      expect(cubit.state.maxAvailableWeek, 4);
    });

    test('selected initial week is sent without student id', () async {
      final repo = _FakeReadRepo(response: _gulf(week: 3));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent(week: 3);
      expect(repo.calls.single, (
        week: 3,
        studentId: null,
        classroomId: 'general',
      ));
    });

    test('response week replaces requested week', () async {
      final repo = _FakeReadRepo(response: _gulf(week: 6));
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent(week: 5);
      expect(cubit.state.selectedWeek, 6);
      expect(cubit.state.maxAvailableWeek, 6);
    });

    test(
      'no classroom options emits empty without evaluations request',
      () async {
        final repo = _FakeReadRepo(classrooms: const []);
        final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
        await cubit.loadForStudent();
        expect(cubit.state.classrooms, isEmpty);
        expect(cubit.state.selectedClassroomId, isNull);
        expect(repo.calls, isEmpty);
        expect(cubit.state.status, ReadOnlyEvaluationsStatus.empty);
        expect(cubit.state.hasNoClassroom, isTrue);
      },
    );

    test('classroom scope is reused by week changes and retry', () async {
      final repo = _FakeReadRepo(response: _egyptian());
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      await cubit.selectClassroom('classroom-ar');
      await cubit.selectWeek(2);
      await cubit.retry();
      expect(repo.calls, hasLength(4));
      expect(
        repo.calls.skip(1).map((call) => call.classroomId),
        everyElement('classroom-ar'),
      );
    });

    test('changing classroom clears data and ignores older response', () async {
      final first =
          Completer<Either<Failure, MeWeeklyEvaluationsResponseModel>>();
      final second =
          Completer<Either<Failure, MeWeeklyEvaluationsResponseModel>>();
      final repo = _FakeReadRepo();
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      repo.handler = (_, _, classroomId) =>
          classroomId == 'arabic' ? first.future : second.future;

      final oldLoad = cubit.selectClassroom('arabic');
      final newLoad = cubit.selectClassroom('english');
      expect(cubit.state.data, isNull);
      second.complete(Right(_egyptian()));
      await newLoad;
      first.complete(Right(_gulf()));
      await oldLoad;

      expect(cubit.state.data?.mode, EvaluationMode.egyptian);
      expect(repo.calls.last.classroomId, 'english');
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

    test('one child sends student profile id instead of user id', () async {
      const child = ParentEvaluationChildModel(
        id: 'student-profile-1',
        userId: 'user-1',
        classrooms: [
          ReadEvaluationReferenceModel(id: 'classroom', name: 'Classroom'),
        ],
      );
      final repo = _FakeReadRepo(children: const [child]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      expect(cubit.state.selectedChildId, 'student-profile-1');
      expect(repo.calls.single.studentId, 'student-profile-1');
      expect(repo.calls.single.studentId, isNot('user-1'));
    });

    test('multiple children select first and send its id', () async {
      final repo = _FakeReadRepo(children: const [_child1, _child2]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      expect(cubit.state.selectedChildId, 'child-1');
      expect(repo.calls.single.studentId, 'child-1');
    });

    test('parent classroom selection uses child classroom id', () async {
      const child = ParentEvaluationChildModel(
        id: 'child',
        classrooms: [
          ReadEvaluationReferenceModel(id: 'private-ar', name: 'Arabic'),
        ],
      );
      final repo = _FakeReadRepo(children: const [child]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      await cubit.selectClassroom('private-ar');
      expect(cubit.state.selectedClassroomId, 'private-ar');
      expect(repo.calls.last.studentId, 'child');
      expect(repo.calls.last.classroomId, 'private-ar');
    });

    test('child without classrooms emits empty without request', () async {
      const child = ParentEvaluationChildModel(id: 'gulf-child');
      final repo = _FakeReadRepo(children: const [child]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);

      await cubit.loadForParent();

      expect(repo.calls, isEmpty);
      expect(cubit.state.classrooms, isEmpty);
      expect(cubit.state.hasNoClassroom, isTrue);
    });

    test(
      'selectChild keeps week and selects the new child first classroom',
      () async {
        final repo = _FakeReadRepo(
          children: const [_child1, _child2],
          response: _gulf(week: 5),
        );
        repo.handler = (week, _, _) =>
            Future.value(Right(_gulf(week: week ?? 5)));
        final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
        await cubit.loadForParent();
        await cubit.selectChild('child-2');
        expect(repo.calls.last, (
          week: 5,
          studentId: 'child-2',
          classroomId: 'class-2',
        ));
        expect(cubit.state.selectedWeek, 5);
        expect(cubit.state.maxAvailableWeek, 5);
        expect(cubit.state.children, hasLength(2));
      },
    );

    test('selectChild ignores blank, unknown, and current child', () async {
      final repo = _FakeReadRepo(children: const [_child1, _child2]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      await cubit.selectChild('');
      await cubit.selectChild('missing');
      await cubit.selectChild('child-1');
      expect(repo.calls, hasLength(1));
    });

    test('one-child parent week request sends student profile id', () async {
      final repo = _FakeReadRepo(children: const [_child1]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      await cubit.selectWeek(2);
      expect(repo.calls.last, (
        week: 2,
        studentId: 'child-1',
        classroomId: 'class-1',
      ));
    });

    test('multi-child parent week request sends selected child', () async {
      final repo = _FakeReadRepo(children: const [_child1, _child2]);
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForParent();
      await cubit.selectChild('child-2');
      await cubit.selectWeek(2);
      expect(repo.calls.last, (
        week: 2,
        studentId: 'child-2',
        classroomId: 'class-2',
      ));
    });
  });

  group('selection and failures', () {
    test('student selectWeek sends week and no student id', () async {
      final repo = _FakeReadRepo();
      final cubit = ReadOnlyWeeklyEvaluationsCubit(repo);
      await cubit.loadForStudent();
      await cubit.selectWeek(2);
      expect(repo.calls.last, (
        week: 2,
        studentId: null,
        classroomId: 'general',
      ));
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
        repo.handler = (week, _, _) =>
            Future.value(Right(_gulf(week: week ?? 2)));

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
      expect(repo.calls.last, (
        week: 3,
        studentId: 'child-1',
        classroomId: 'class-1',
      ));
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
      repo.handler = (week, _, _) => week == 2 ? older.future : newer.future;
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

const _child1 = ParentEvaluationChildModel(
  id: 'child-1',
  fullName: 'One',
  classrooms: [ReadEvaluationReferenceModel(id: 'class-1', name: 'Class One')],
);
const _child2 = ParentEvaluationChildModel(
  id: 'child-2',
  fullName: 'Two',
  classrooms: [ReadEvaluationReferenceModel(id: 'class-2', name: 'Class Two')],
);

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
    this.classrooms = const [
      ReadEvaluationReferenceModel(id: 'general', name: 'General'),
      ReadEvaluationReferenceModel(id: 'arabic', name: 'Private Arabic'),
      ReadEvaluationReferenceModel(id: 'english', name: 'Private English'),
      ReadEvaluationReferenceModel(id: 'classroom-ar', name: 'Arabic'),
    ],
    MeWeeklyEvaluationsResponseModel? response,
    this.failure,
  }) : response = response ?? _gulf();

  final List<ParentEvaluationChildModel> children;
  final List<ReadEvaluationReferenceModel> classrooms;
  final MeWeeklyEvaluationsResponseModel response;
  Failure? failure;
  Future<Either<Failure, MeWeeklyEvaluationsResponseModel>> Function(
    int?,
    String?,
    String?,
  )?
  handler;
  final calls = <({int? week, String? studentId, String? classroomId})>[];

  @override
  Future<Either<Failure, List<ParentEvaluationChildModel>>>
  getParentChildren() async => Right(children);

  @override
  Future<Either<Failure, List<ReadEvaluationReferenceModel>>>
  getMyClassrooms() async => Right(classrooms);

  @override
  Future<Either<Failure, MeWeeklyEvaluationsResponseModel>> getMyEvaluations({
    int? week,
    String? studentId,
    String? classroomId,
  }) {
    calls.add((week: week, studentId: studentId, classroomId: classroomId));
    final callback = handler;
    if (callback != null) return callback(week, studentId, classroomId);
    final currentFailure = failure;
    return Future.value(
      currentFailure == null ? Right(response) : Left(currentFailure),
    );
  }
}
