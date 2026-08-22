import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assignment_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an older response cannot overwrite the latest request', () async {
    final repo = _PendingRepo();
    final cubit = GetTeacherAssignmentsCubit(repo);
    final oldRequest = cubit.getAssignments(status: 'old');
    final newRequest = cubit.getAssignments(status: 'new');
    final latest = TeacherAssignmentsResponseModel.placeholder();

    repo.results[1].complete(Right(latest));
    await newRequest;
    repo.results[0].complete(
      Right(TeacherAssignmentsResponseModel.placeholder()),
    );
    await oldRequest;

    final state = cubit.state as GetTeacherAssignmentsSuccess;
    expect(state.assignments, same(latest));
    await cubit.close();
  });
}

class _PendingRepo implements AssignmentsRepo {
  final results =
      <Completer<Either<Failure, TeacherAssignmentsResponseModel>>>[];

  @override
  Future<Either<Failure, TeacherAssignmentsResponseModel>> getAssignments({
    String? status,
  }) {
    final result =
        Completer<Either<Failure, TeacherAssignmentsResponseModel>>();
    results.add(result);
    return result.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
