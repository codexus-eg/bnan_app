import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/supervisor_management/data/models/get_supervisor_classrooms_response_model.dart';
import 'package:bnan_app/features/supervisor_management/data/repo/supervisor_management_repo.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_cubit.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cubit emits success from repository response', () async {
    final cubit = GetSupervisorClassroomsCubit(
      FakeSupervisorManagementRepo(
        const Right(GetSupervisorClassroomsResponseModel(success: true)),
      ),
    );

    await cubit.getMyClassrooms();

    expect(cubit.state, isA<GetSupervisorClassroomsSuccess>());
    await cubit.close();
  });

  test('cubit exposes failure message as a string', () async {
    final cubit = GetSupervisorClassroomsCubit(
      FakeSupervisorManagementRepo(Left(Failure(message: 'failed'))),
    );

    await cubit.getMyClassrooms();

    final state = cubit.state as GetSupervisorClassroomsFailure;
    expect(state.errorMessage, 'failed');
    await cubit.close();
  });
}

class FakeSupervisorManagementRepo implements SupervisorManagementRepo {
  FakeSupervisorManagementRepo(this.result);

  final Either<Failure, GetSupervisorClassroomsResponseModel> result;

  @override
  Future<Either<Failure, GetSupervisorClassroomsResponseModel>>
  getMyClassrooms() async => result;
}
