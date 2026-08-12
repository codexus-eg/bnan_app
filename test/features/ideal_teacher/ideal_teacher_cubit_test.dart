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
}

const _teacher = SupervisorTeacherModel(
  id: 't1',
  name: 'Teacher',
  avatar: '',
  subjects: [],
  classrooms: [],
);

class _Repo implements SupervisorIdealTeacherRepo {
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
