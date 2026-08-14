import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';
import 'package:bnan_app/features/grades_management/data/models/grades_response_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Egyptian active grades win over stale responses', () async {
    final repo = _Repo();
    final cubit = GetGradesCubit(repo);
    final first = cubit.getCurriculumGrades(curriculumId: 'a');
    final second = cubit.getCurriculumGrades(curriculumId: 'b');
    repo.requests['b']!.complete(Right(_response('b')));
    await second;
    repo.requests['a']!.complete(Right(_response('a')));
    await first;
    final state = cubit.state as GetGradesSuccess;
    expect(state.grades.single.id, 'b');
    await cubit.close();
  });
}

GradesResponseModel _response(String id) => GradesResponseModel(
  success: true,
  length: 1,
  data: [GradeModel(id: id, name: id, isActive: true, subjects: const [])],
);

class _Repo implements AuthRepo {
  final requests = <String, Completer<Either<Failure, GradesResponseModel>>>{};
  @override
  getCurriculumGrades({required String curriculumId}) =>
      (requests[curriculumId] ??= Completer()).future;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
