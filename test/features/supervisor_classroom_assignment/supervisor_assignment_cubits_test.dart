import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/assign_supervisor_request_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/supervisor_assignments_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/unassign_supervisor_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_state.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/supervisor_assignment_actions/supervisor_assignment_actions_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/supervisor_assignment_actions/supervisor_assignment_actions_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'list cubit starts initial then loads one request successfully',
    () async {
      final repo = _FakeRepo();
      final cubit = GetSupervisorsCubit(repo);
      expect(cubit.state, isA<GetSupervisorsInitial>());
      final states = <GetSupervisorsState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.getSupervisors();
      await Future<void>.delayed(Duration.zero);

      expect(states.first, isA<GetSupervisorsLoading>());
      expect((cubit.state as GetSupervisorsSuccess).supervisors, hasLength(1));
      expect(repo.listCalls, 1);
      await subscription.cancel();
      await cubit.close();
    },
  );

  test('empty list is success and failure preserves message', () async {
    final repo = _FakeRepo(
      listResponse: const Right(GetSupervisorsResponseModel()),
    );
    final cubit = GetSupervisorsCubit(repo);
    await cubit.getSupervisors();
    expect((cubit.state as GetSupervisorsSuccess).supervisors, isEmpty);
    repo.listResponse = Left(Failure(message: 'failed'));
    await cubit.getSupervisors();
    expect((cubit.state as GetSupervisorsFailure).errorMessage, 'failed');
  });

  test(
    'closing while list request is pending never emits after close',
    () async {
      final completer =
          Completer<Either<Failure, GetSupervisorsResponseModel>>();
      final repo = _FakeRepo(listCompleter: completer);
      final cubit = GetSupervisorsCubit(repo);

      final request = cubit.getSupervisors();
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, isA<GetSupervisorsLoading>());
      await cubit.close();
      completer.complete(const Right(GetSupervisorsResponseModel()));

      await expectLater(request, completes);
      expect(repo.listCalls, 1);
      expect(cubit.isClosed, isTrue);
    },
  );

  test('assign maps all classroom ids and calls repository once', () async {
    final repo = _FakeRepo();
    final cubit = SupervisorAssignmentActionsCubit(repo);
    final states = <SupervisorAssignmentActionsState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.assignSupervisorToClassrooms(
      supervisorId: 'supervisor-1',
      classroomIds: ['class-1', 'class-2'],
    );
    await Future<void>.delayed(Duration.zero);

    expect(states.first, isA<AssignSupervisorLoading>());
    expect(cubit.state, isA<AssignSupervisorSuccess>());
    expect(repo.assignCalls, 1);
    expect(repo.lastRequest?.assignments.map((item) => item.classroomId), [
      'class-1',
      'class-2',
    ]);
    await subscription.cancel();
  });

  test('empty assign ids do not call repository', () async {
    final repo = _FakeRepo();
    final cubit = SupervisorAssignmentActionsCubit(repo);
    await cubit.assignSupervisorToClassrooms(
      supervisorId: 'supervisor-1',
      classroomIds: const [],
    );
    expect(repo.assignCalls, 0);
  });

  test('unassign emits scoped failure and calls repository once', () async {
    final repo = _FakeRepo(
      unassignResponse: Left(Failure(message: 'cannot remove')),
    );
    final cubit = SupervisorAssignmentActionsCubit(repo);
    await cubit.unassignSupervisorFromClassroom(
      supervisorId: 'supervisor-1',
      classroomId: 'class-1',
    );
    final state = cubit.state as UnassignSupervisorFailure;
    expect(state.errorMessage, 'cannot remove');
    expect(state.supervisorId, 'supervisor-1');
    expect(state.classroomId, 'class-1');
    expect(repo.unassignCalls, 1);
  });
}

class _FakeRepo implements SupervisorAssignmentRepo {
  _FakeRepo({
    Either<Failure, GetSupervisorsResponseModel>? listResponse,
    this.listCompleter,
    this.unassignResponse = const Right(UnassignSupervisorResponseModel()),
  }) : listResponse =
           listResponse ??
           const Right(
             GetSupervisorsResponseModel(data: [SupervisorModel(id: 'one')]),
           );

  Either<Failure, GetSupervisorsResponseModel> listResponse;
  final Completer<Either<Failure, GetSupervisorsResponseModel>>? listCompleter;
  final Either<Failure, UnassignSupervisorResponseModel> unassignResponse;
  int listCalls = 0;
  int assignCalls = 0;
  int unassignCalls = 0;
  AssignSupervisorRequestModel? lastRequest;

  @override
  Future<Either<Failure, GetSupervisorsResponseModel>> getSupervisors() async {
    listCalls++;
    if (listCompleter != null) return listCompleter!.future;
    return listResponse;
  }

  @override
  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  assignSupervisorToClassrooms({
    required String supervisorId,
    required AssignSupervisorRequestModel request,
  }) async {
    assignCalls++;
    lastRequest = request;
    return const Right(SupervisorAssignmentsResponseModel());
  }

  @override
  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  getSupervisorAssignments({required String supervisorId}) async =>
      const Right(SupervisorAssignmentsResponseModel());

  @override
  Future<Either<Failure, UnassignSupervisorResponseModel>>
  unassignSupervisorFromClassroom({
    required String supervisorId,
    required String classroomId,
  }) async {
    unassignCalls++;
    return unassignResponse;
  }
}
