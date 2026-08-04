import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads page one then appends page two without duplicate ids', () async {
    final repo = _Repo([Right(_response(10)), Right(_response(10, start: 9))]);
    final cubit = GetSubjectsCubit(repo);

    await cubit.getSubjects();
    await cubit.loadMore();

    expect(repo.calls, [(1, 10), (2, 10)]);
    expect(cubit.currentPage, 2);
    expect(cubit.subjects, hasLength(19));
    expect(cubit.subjects.map((item) => item.id).toSet(), hasLength(19));
    expect(cubit.subjects.last.id, '18');
    await cubit.close();
  });

  test('short or empty page stops loading without clearing items', () async {
    final repo = _Repo([Right(_response(10)), Right(_response(0))]);
    final cubit = GetSubjectsCubit(repo);
    await cubit.getSubjects();

    await cubit.loadMore();

    expect(cubit.subjects, hasLength(10));
    expect(cubit.currentPage, 1);
    expect(cubit.hasMore, isFalse);
    await cubit.close();
  });

  test('load-more failure preserves items and permits retry', () async {
    final repo = _Repo([
      Right(_response(10)),
      Left(Failure(message: 'failed')),
      Right(_response(2, start: 10)),
    ]);
    final cubit = GetSubjectsCubit(repo);
    await cubit.getSubjects();

    await cubit.loadMore();
    expect(cubit.state, isA<GetSubjectsLoadMoreFailure>());
    expect(cubit.subjects, hasLength(10));
    expect(cubit.isLoadingMore, isFalse);
    await cubit.loadMore();

    expect(cubit.subjects, hasLength(12));
    expect(cubit.hasMore, isFalse);
    await cubit.close();
  });

  test('does not send two load-more requests concurrently', () async {
    final repo = _PendingLoadMoreRepo();
    final cubit = GetSubjectsCubit(repo);
    await cubit.getSubjects();

    final first = cubit.loadMore();
    await Future<void>.delayed(Duration.zero);
    await cubit.loadMore();
    expect(repo.calls, [(1, 10), (2, 10)]);

    repo.complete(_response(1, start: 10));
    await first;
    await cubit.close();
  });
}

class _Repo implements SubjectsRepo {
  _Repo(this.responses);
  final List<Either<Failure, SubjectsResponseModel>> responses;
  final List<(int, int)> calls = [];

  @override
  Future<Either<Failure, SubjectsResponseModel>> getSubjects({
    required int page,
    required int limit,
  }) async {
    calls.add((page, limit));
    return responses.removeAt(0);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PendingLoadMoreRepo implements SubjectsRepo {
  final calls = <(int, int)>[];
  final completer = Completer<Either<Failure, SubjectsResponseModel>>();

  @override
  Future<Either<Failure, SubjectsResponseModel>> getSubjects({
    required int page,
    required int limit,
  }) {
    calls.add((page, limit));
    if (page == 1) return Future.value(Right(_response(10)));
    return completer.future;
  }

  void complete(SubjectsResponseModel response) =>
      completer.complete(Right(response));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SubjectsResponseModel _response(int length, {int start = 0}) {
  return SubjectsResponseModel(
    success: true,
    length: length,
    data: List.generate(
      length,
      (index) => SubjectModel(
        id: '${start + index}',
        name: 'Subject ${start + index}',
        isActive: true,
      ),
    ),
  );
}
