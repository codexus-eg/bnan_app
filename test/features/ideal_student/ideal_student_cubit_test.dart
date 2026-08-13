import 'dart:async';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_ranking_response.dart';
import 'package:bnan_app/features/ideal_student/data/repos/ideal_student_repo.dart';
import 'package:bnan_app/features/ideal_student/presentation/manager/ideal_student_cubit.dart';
import 'package:bnan_app/features/ideal_student/presentation/manager/ideal_student_state.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'selects first classroom and paginates without duplicate pages',
    () async {
      final repo = _Repo([
        _response(page: 1, pages: 2),
        _response(page: 2, pages: 2),
      ]);
      final cubit = IdealStudentCubit(repo);
      await cubit.setClassrooms(const [_classA]);
      await cubit.loadMore();
      await cubit.loadMore();
      expect(repo.calls, [('a', 1), ('a', 2)]);
      expect(cubit.ranking, hasLength(2));
      await cubit.close();
    },
  );

  test('classroom change clears old data and ignores stale response', () async {
    final first = Completer<Either<Failure, IdealStudentRankingResponse>>();
    final repo = _AsyncRepo(first);
    final cubit = IdealStudentCubit(repo);
    final old = cubit.selectClassroom(_classA);
    await Future<void>.delayed(Duration.zero);
    final current = cubit.selectClassroom(_classB);
    await current;
    first.complete(Right(_response(name: 'Old')));
    await old;
    expect(cubit.selectedClassroom?.id, 'b');
    expect(cubit.idealStudent?.name, 'Student b');
    await cubit.close();
  });

  test('provisional displays while insufficient data is empty', () async {
    final repo = _Repo([
      _response(status: 'provisional'),
      _response(status: 'insufficient_data', ideal: false),
    ]);
    final cubit = IdealStudentCubit(repo);
    await cubit.selectClassroom(_classA);
    expect(cubit.state, isA<IdealStudentLoaded>());
    await cubit.selectClassroomAfterFailure(_classB);
    expect(cubit.state, isA<IdealStudentEmpty>());
    await cubit.close();
  });

  test(
    'valid ranking is shown when the separate ideal student is null',
    () async {
      final cubit = IdealStudentCubit(
        _Repo([_response(status: 'final', ideal: false)]),
      );

      await cubit.selectClassroom(_classA);

      expect(cubit.state, isA<IdealStudentLoaded>());
      expect(cubit.ranking, hasLength(1));
      expect(cubit.idealStudent?.name, 'Student 1');
      await cubit.close();
    },
  );

  test('winner fallback uses rank instead of response list order', () async {
    final response = IdealStudentRankingResponse.fromJson({
      'data': {
        'status': 'final',
        'idealStudent': null,
        'ranking': [_rankedItem('Second', 2), _rankedItem('First', 1)],
      },
    });
    final cubit = IdealStudentCubit(_Repo([response]));

    await cubit.selectClassroom(_classA);

    expect(cubit.state, isA<IdealStudentLoaded>());
    expect(cubit.idealStudent?.name, 'First');
    await cubit.close();
  });

  test('initial failure emits retryable failure', () async {
    final cubit = IdealStudentCubit(_FailureRepo());
    await cubit.selectClassroom(_classA);
    expect(cubit.state, isA<IdealStudentFailure>());
    await cubit.close();
  });
}

const _classA = PlanClassroomOption(id: 'a', name: 'A');
const _classB = PlanClassroomOption(id: 'b', name: 'B');

IdealStudentRankingResponse _response({
  int page = 1,
  int pages = 1,
  String status = 'final',
  String name = 'Student',
  bool ideal = true,
}) => IdealStudentRankingResponse.fromJson({
  'data': {
    'status': status,
    'idealStudent': ideal ? _item(name) : null,
    'ranking': [_item('$name $page')],
    'pagination': {'page': page, 'limit': 20, 'total': pages, 'pages': pages},
  },
});

Map<String, dynamic> _item(String name) => {
  'rank': 1,
  'student': {'id': name, 'fullName': name},
  'weeklyPoints': 90,
};

Map<String, dynamic> _rankedItem(String name, int rank) => {
  'rank': rank,
  'student': {'id': name, 'fullName': name},
  'weeklyPoints': 90 - rank,
};

class _Repo implements IdealStudentRepo {
  _Repo(this.responses);
  final List<IdealStudentRankingResponse> responses;
  final calls = <(String, int)>[];

  @override
  Future<Either<Failure, IdealStudentRankingResponse>> getWeeklyRanking({
    required String classroomId,
    required int page,
    required int limit,
  }) async {
    calls.add((classroomId, page));
    return Right(responses.removeAt(0));
  }
}

class _AsyncRepo implements IdealStudentRepo {
  _AsyncRepo(this.first);
  final Completer<Either<Failure, IdealStudentRankingResponse>> first;
  int calls = 0;

  @override
  Future<Either<Failure, IdealStudentRankingResponse>> getWeeklyRanking({
    required String classroomId,
    required int page,
    required int limit,
  }) {
    calls++;
    if (calls == 1) return first.future;
    return Future.value(Right(_response(name: 'Student $classroomId')));
  }
}

class _FailureRepo implements IdealStudentRepo {
  @override
  Future<Either<Failure, IdealStudentRankingResponse>> getWeeklyRanking({
    required String classroomId,
    required int page,
    required int limit,
  }) async => Left(Failure(message: 'failed'));
}
