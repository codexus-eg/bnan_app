import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_details_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classrooms_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create request sends supervisorId and never supervisor', () {
    const request = ClassroomRequestModel(
      name: 'Class A',
      curriculumId: 'curriculum-1',
      gradeId: 'grade-1',
      supervisorId: 'supervisor-1',
    );

    expect(request.toJson(), {
      'name': 'Class A',
      'curriculum': 'curriculum-1',
      'grade': 'grade-1',
      'supervisorId': 'supervisor-1',
    });
    expect(request.toJson(), isNot(contains('supervisor')));
  });

  test(
    'create forwards selected supervisor and preserves success flow',
    () async {
      final repo = _FakeClassroomsRepo();
      final cubit = ClassroomActionsCubit(repo);
      const request = ClassroomRequestModel(
        name: 'Class A',
        supervisorId: 'supervisor-1',
      );

      await cubit.createClassroom(request);

      expect(repo.lastRequest?.supervisorId, 'supervisor-1');
      expect(cubit.state, isA<CreateClassroomSuccess>());
    },
  );

  test('create ignores repeated submit while request is pending', () async {
    final repo = _FakeClassroomsRepo()..pending = Completer();
    final cubit = ClassroomActionsCubit(repo);
    const request = ClassroomRequestModel(name: 'A', supervisorId: 's1');

    final first = cubit.createClassroom(request);
    final second = cubit.createClassroom(request);
    repo.pending!.complete(const Right(null));
    await Future.wait([first, second]);

    expect(repo.createCalls, 1);
  });
}

class _FakeClassroomsRepo implements ClassroomsRepo {
  int createCalls = 0;
  ClassroomRequestModel? lastRequest;
  Completer<Either<Failure, void>>? pending;

  @override
  Future<Either<Failure, void>> createClassroom(ClassroomRequestModel model) {
    createCalls++;
    lastRequest = model;
    return pending?.future ?? Future.value(const Right(null));
  }

  @override
  Future<Either<Failure, ClassroomsResponseModel>> getClassrooms() =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, ClassroomDetailsResponseModel>> getClassroomDetails(
    String classroomId,
  ) => throw UnimplementedError();
  @override
  Future<Either<Failure, void>> updateClassroom(
    String classroomId,
    ClassroomRequestModel model,
  ) => throw UnimplementedError();
}
