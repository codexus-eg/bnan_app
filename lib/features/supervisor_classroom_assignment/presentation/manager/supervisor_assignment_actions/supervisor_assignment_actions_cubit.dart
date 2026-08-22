import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/assign_supervisor_request_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'supervisor_assignment_actions_state.dart';

class SupervisorAssignmentActionsCubit
    extends Cubit<SupervisorAssignmentActionsState> {
  SupervisorAssignmentActionsCubit(this.repo)
    : super(const SupervisorAssignmentActionsInitial());

  final SupervisorAssignmentRepo repo;

  Future<void> assignSupervisorToClassrooms({
    required String supervisorId,
    required List<String> classroomIds,
  }) async {
    if (isClosed) return;
    final ids = classroomIds.where((id) => id.trim().isNotEmpty).toList();
    if (supervisorId.isEmpty || ids.isEmpty) return;
    emit(AssignSupervisorLoading(supervisorId));
    final request = AssignSupervisorRequestModel(
      assignments: ids
          .map((id) => AssignSupervisorClassroomRequestModel(classroomId: id))
          .toList(growable: false),
    );
    final result = await repo.assignSupervisorToClassrooms(
      supervisorId: supervisorId,
      request: request,
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(AssignSupervisorFailure(supervisorId, failure.message));
      },
      (response) {
        if (isClosed) return;
        emit(
          AssignSupervisorSuccess(
            supervisorId: supervisorId,
            response: response,
          ),
        );
      },
    );
  }

  Future<void> unassignSupervisorFromClassroom({
    required String supervisorId,
    required String classroomId,
  }) async {
    if (isClosed) return;
    if (supervisorId.isEmpty || classroomId.isEmpty) return;
    emit(UnassignSupervisorLoading(supervisorId, classroomId));
    final result = await repo.unassignSupervisorFromClassroom(
      supervisorId: supervisorId,
      classroomId: classroomId,
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          UnassignSupervisorFailure(
            supervisorId: supervisorId,
            classroomId: classroomId,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        if (isClosed) return;
        emit(
          UnassignSupervisorSuccess(
            supervisorId: supervisorId,
            classroomId: classroomId,
            response: response,
          ),
        );
      },
    );
  }
}
