import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/data/models/subjects_pagination_model.dart';
import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('moves next and previous using API pagination and perPage', () async {
    final repo = _SubjectsRepo();
    final cubit = GetSubjectsCubit(repo);

    await cubit.getSubjects();
    await cubit.nextPage();
    await cubit.previousPage();

    expect(repo.calls, [(1, 10), (2, 20), (1, 20)]);
    expect(cubit.currentPage, 1);
    await cubit.close();
  });

  test(
    'reloads current page and steps back after last-item deletion',
    () async {
      final repo = _SubjectsRepo();
      final cubit = GetSubjectsCubit(repo);

      await cubit.getSubjects(page: 2);
      await cubit.reloadCurrentPage();
      await cubit.reloadAfterDelete(deletedPageItemCount: 1);

      expect(repo.calls.map((call) => call.$1), [2, 2, 1]);
      await cubit.close();
    },
  );

  test('does not duplicate requests while loading', () async {
    final repo = _PendingSubjectsRepo();
    final cubit = GetSubjectsCubit(repo);

    final first = cubit.getSubjects();
    await Future<void>.delayed(Duration.zero);
    await cubit.getSubjects(page: 2);
    expect(repo.calls, 1);

    repo.complete(_response(1));
    await first;
    await cubit.close();
  });
}

class _SubjectsRepo implements SubjectsRepo {
  final List<(int, int)> calls = [];

  @override
  Future<Either<Failure, SubjectsResponseModel>> getSubjects({
    required int page,
    required int perPage,
  }) async {
    calls.add((page, perPage));
    return Right(_response(page));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PendingSubjectsRepo implements SubjectsRepo {
  final _completer = Completer<Either<Failure, SubjectsResponseModel>>();
  int calls = 0;

  @override
  Future<Either<Failure, SubjectsResponseModel>> getSubjects({
    required int page,
    required int perPage,
  }) {
    calls++;
    return _completer.future;
  }

  void complete(SubjectsResponseModel response) =>
      _completer.complete(Right(response));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SubjectsResponseModel _response(int page) => SubjectsResponseModel(
  success: true,
  length: 1,
  pagination: SubjectsPaginationModel(
    currentPage: page,
    perPage: 20,
    total: 40,
    lastPage: 2,
  ),
  data: [SubjectModel(id: '$page', name: 'Math', isActive: true)],
);
