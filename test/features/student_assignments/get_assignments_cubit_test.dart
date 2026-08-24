import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/repo/student_assignments_repo.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_assignment/get_assignments_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_assignment/get_assignments_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not emit when response completes after close', () async {
    final repo = _AssignmentsRepo();
    final cubit = GetAssignmentsCubit(repo);
    final request = cubit.getMyAssignments();

    expect(cubit.state, isA<GetAssignmentsLoading>());
    await cubit.close();
    repo.complete(const Right(_response));

    await expectLater(request, completes);
  });

  test('emits loading then success', () async {
    final repo = _AssignmentsRepo();
    final cubit = GetAssignmentsCubit(repo);
    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<GetAssignmentsLoading>(),
        isA<GetAssignmentsSuccess>(),
      ]),
    );

    final request = cubit.getMyAssignments();
    repo.complete(const Right(_response));
    await request;
    await states;

    await cubit.close();
  });

  test('emits loading then failure', () async {
    final repo = _AssignmentsRepo();
    final cubit = GetAssignmentsCubit(repo);
    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<GetAssignmentsLoading>(),
        isA<GetAssignmentsFailure>(),
      ]),
    );

    final request = cubit.getMyAssignments();
    repo.complete(Left(Failure(message: 'server')));
    await request;
    await states;

    await cubit.close();
  });
}

const _response = AssignmentsResponseModel(
  success: true,
  results: 0,
  assignments: [],
);

class _AssignmentsRepo implements StudentAssignmentsRepo {
  final _result = Completer<Either<Failure, AssignmentsResponseModel>>();

  @override
  Future<Either<Failure, AssignmentsResponseModel>> getMyAssignments() =>
      _result.future;

  void complete(Either<Failure, AssignmentsResponseModel> result) =>
      _result.complete(result);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
