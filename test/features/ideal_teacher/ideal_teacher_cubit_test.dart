import 'dart:async';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('load covers success, empty and failure', () async {
    final success = SupervisorIdealTeacherCubit(
      _Repo(teachers: const [_teacher]),
    );
    await success.loadTeachers();
    expect(success.state.teachers, const [_teacher]);
    final empty = SupervisorIdealTeacherCubit(_Repo());
    await empty.loadTeachers();
    expect(empty.state.teachers, isEmpty);
    final failure = SupervisorIdealTeacherCubit(_Repo(failLoad: true));
    await failure.loadTeachers();
    expect(failure.state.status, SupervisorIdealTeacherStatus.failure);
  });

  test(
    'selection supports multiple ids without duplicates and toggles off',
    () {
      final cubit = SupervisorIdealTeacherCubit(_Repo());
      cubit.selectTeacher('t1');
      cubit.selectTeacher('t1');
      cubit.selectTeacher('t2');
      expect(cubit.state.selectedTeacherIds, {'t1', 't2'});
      cubit.unselectTeacher('t1');
      expect(cubit.state.selectedTeacherIds, {'t2'});
      cubit.toggleTeacher('t2');
      expect(cubit.state.selectedTeacherIds, isEmpty);
    },
  );

  test(
    'empty cannot submit and success sends ids then clears selection',
    () async {
      final repo = _Repo();
      final cubit = SupervisorIdealTeacherCubit(repo);
      await cubit.submitIdealTeachers();
      expect(repo.submitCalls, 0);
      cubit.toggleTeacher('t1');
      cubit.toggleTeacher('t2');
      await cubit.submitIdealTeachers(signerName: 'Signer');
      expect(repo.ids, ['t1', 't2']);
      expect(repo.signer, 'Signer');
      expect(cubit.state.selectedTeacherIds, isEmpty);
    },
  );

  test('failure keeps selection and double tap creates one request', () async {
    final gate = Completer<Either<Failure, Unit>>();
    final repo = _Repo(submitResult: gate.future);
    final cubit = SupervisorIdealTeacherCubit(repo)..toggleTeacher('t1');
    final first = cubit.submitIdealTeachers();
    final second = cubit.submitIdealTeachers();
    expect(repo.submitCalls, 1);
    gate.complete(Left(Failure(message: 'duplicate')));
    await Future.wait([first, second]);
    expect(cubit.state.selectedTeacherIds, {'t1'});
    expect(cubit.state.message, 'duplicate');
  });

  test('issuance tracking increments issuanceEventId once and selection does not re-emit it', () async {
    final repo = _Repo();
    final cubit = SupervisorIdealTeacherCubit(repo);

    expect(cubit.state.issuanceEventId, 0);
    expect(cubit.state.issuanceSuccess, isNull);

    // 1. Success scenario
    cubit.selectTeacher('t1');
    await cubit.submitIdealTeachers(signerName: 'Signer');

    expect(cubit.state.issuanceEventId, 1);
    expect(cubit.state.issuanceSuccess, isTrue);
    expect(cubit.state.status, SupervisorIdealTeacherStatus.success);
    expect(cubit.state.selectedTeacherIds, isEmpty);

    // 2. Toggle same teacher afterward
    cubit.toggleTeacher('t1');
    expect(cubit.state.issuanceEventId, 1);
    expect(cubit.state.status, SupervisorIdealTeacherStatus.loaded);
    expect(cubit.state.message, isEmpty);

    // 3. Select different teacher afterward
    cubit.selectTeacher('t2');
    expect(cubit.state.issuanceEventId, 1);
    expect(cubit.state.status, SupervisorIdealTeacherStatus.loaded);

    // 4. Clear selection
    cubit.clearSelection();
    expect(cubit.state.issuanceEventId, 1);
    expect(cubit.state.selectedTeacherIds, isEmpty);

    // 5. Search query change
    cubit.setSearchQuery('ahmed');
    expect(cubit.state.issuanceEventId, 1);
    expect(cubit.state.status, SupervisorIdealTeacherStatus.loaded);

    // 6. Failed issuance
    final failRepo = _Repo(
      submitResult: Future.value(Left(Failure(message: 'duplicate_cert'))),
    );
    final failCubit = SupervisorIdealTeacherCubit(failRepo);
    failCubit.selectTeacher('t1');
    await failCubit.submitIdealTeachers();

    expect(failCubit.state.issuanceEventId, 1);
    expect(failCubit.state.issuanceSuccess, isFalse);
    expect(failCubit.state.issuanceMessage, 'duplicate_cert');
    expect(failCubit.state.status, SupervisorIdealTeacherStatus.failure);

    // Toggle teacher after failure
    failCubit.toggleTeacher('t1');
    expect(failCubit.state.issuanceEventId, 1);
    expect(failCubit.state.status, SupervisorIdealTeacherStatus.loaded);
    expect(failCubit.state.message, isEmpty);

    // 7. Genuinely new issuance increments issuanceEventId
    failCubit.selectTeacher('t2');
    await failCubit.submitIdealTeachers();
    expect(failCubit.state.issuanceEventId, 2);
  });

  test('search filtering is case-insensitive, trims whitespace, and preserves selection', () async {
    final cubit = SupervisorIdealTeacherCubit(
      _Repo(teachers: const [
        SupervisorTeacherModel(
          id: 't1',
          name: 'Ahmed Mohamed',
          avatar: '',
          subjects: [],
          classrooms: [],
        ),
        SupervisorTeacherModel(
          id: 't2',
          name: 'Sara Ali',
          avatar: '',
          subjects: [],
          classrooms: [],
        ),
      ]),
    );
    await cubit.loadTeachers();
    cubit.selectTeacher('t1');

    cubit.setSearchQuery('  ahmed ');
    expect(cubit.state.filteredTeachers.length, 1);
    expect(cubit.state.filteredTeachers.first.id, 't1');
    expect(cubit.state.selectedTeacherIds, {'t1'});

    cubit.setSearchQuery('sara');
    expect(cubit.state.filteredTeachers.length, 1);
    expect(cubit.state.filteredTeachers.first.id, 't2');
    expect(cubit.state.selectedTeacherIds, {'t1'}); // preserved!

    cubit.setSearchQuery('');
    expect(cubit.state.filteredTeachers.length, 2);
  });

  test('setActiveTab switches active tab', () {
    final cubit = SupervisorIdealTeacherCubit(_Repo());
    expect(cubit.state.activeTab, IdealTeacherTab.idealTeacher);
    cubit.setActiveTab(IdealTeacherTab.classroomPoints);
    expect(cubit.state.activeTab, IdealTeacherTab.classroomPoints);
  });
}

const _teacher = SupervisorTeacherModel(
  id: 't1',
  name: 'Teacher',
  avatar: '',
  subjects: [],
  classrooms: [],
);

class _Repo extends SupervisorIdealTeacherRepo {
  _Repo({this.teachers = const [], this.failLoad = false, this.submitResult});
  final List<SupervisorTeacherModel> teachers;
  final bool failLoad;
  final Future<Either<Failure, Unit>>? submitResult;
  int submitCalls = 0;
  List<String>? ids;
  String? signer;
  @override
  Future<Either<Failure, List<SupervisorTeacherModel>>> getTeachers() async =>
      failLoad ? Left(Failure(message: 'load failed')) : Right(teachers);
  @override
  Future<Either<Failure, Unit>> issueIdealTeachers({
    required List<String> teacherIds,
    String? signerName,
  }) {
    submitCalls++;
    ids = teacherIds;
    signer = signerName;
    return submitResult ?? Future.value(const Right(unit));
  }
}
