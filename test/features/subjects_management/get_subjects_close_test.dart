import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not emit when refresh completes after close', () async {
    final repo = _PendingSubjectsRepo();
    final cubit = GetSubjectsCubit(repo);
    final request = cubit.refreshSubjects();

    await cubit.close();
    repo.complete();

    await expectLater(request, completes);
  });
}

class _PendingSubjectsRepo implements SubjectsRepo {
  final response = Completer<Either<Failure, SubjectsResponseModel>>();

  @override
  Future<Either<Failure, SubjectsResponseModel>> getSubjects({
    required int page,
    required int limit,
  }) => response.future;

  void complete() => response.complete(
    const Right(SubjectsResponseModel(success: true, length: 0, data: [])),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
