import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_classrooms_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('request completion after close does not emit', () async {
    final repo = _PendingRepo();
    final cubit = GetTeacherClassroomsCubit(repo);
    final request = cubit.getMyClassrooms();
    await cubit.close();

    repo.result.complete(
      const Right(TeacherClassroomsResponseModel(classrooms: [])),
    );

    await expectLater(request, completes);
  });
}

class _PendingRepo implements AssignmentsRepo {
  final result = Completer<Either<Failure, TeacherClassroomsResponseModel>>();

  @override
  Future<Either<Failure, TeacherClassroomsResponseModel>> getMyClassrooms() =>
      result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
