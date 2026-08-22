import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_auth/data/models/subject_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('late subjects response cannot replace the selected grade', () async {
    final repo = _Repo();
    final cubit = GetCurriculmSubjectsCubit(repo);
    final first = cubit.getCurriculumSubjects(
      curriculumId: 'curriculum',
      gradeId: 'a',
    );
    final second = cubit.getCurriculumSubjects(
      curriculumId: 'curriculum',
      gradeId: 'b',
    );
    repo.requests['b']!.complete(Right(_response('b')));
    await second;
    repo.requests['a']!.complete(Right(_response('a')));
    await first;
    final state = cubit.state as GetSubjectsSuccess;
    expect(state.subjects.single.id, 'b');
    await cubit.close();
  });
}

SubjectsResponseModel _response(String id) => SubjectsResponseModel(
  success: true,
  subjects: [
    SubjectModel(id: id, name: id, grade: id, curriculum: 'c', isActive: true),
  ],
);

class _Repo implements AuthRepo {
  final requests =
      <String, Completer<Either<Failure, SubjectsResponseModel>>>{};
  @override
  getCurriculumSubjects({
    required String curriculumId,
    required String gradeId,
  }) => (requests[gradeId] ??= Completer()).future;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
