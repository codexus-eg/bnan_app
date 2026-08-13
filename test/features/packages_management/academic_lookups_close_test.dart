import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not emit when curriculum load completes after close', () async {
    final repo = _PendingLookupsRepo();
    final cubit = AcademicLookupsCubit(repo: repo);
    final request = cubit.loadCurriculums();

    await cubit.close();
    repo.complete();

    await expectLater(request, completes);
  });
}

class _PendingLookupsRepo implements AcademicLookupsRepo {
  final response = Completer<Either<Failure, List<AcademicCurriculumModel>>>();

  @override
  Future<Either<Failure, List<AcademicCurriculumModel>>> getCurriculums() =>
      response.future;

  void complete() => response.complete(const Right([]));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
