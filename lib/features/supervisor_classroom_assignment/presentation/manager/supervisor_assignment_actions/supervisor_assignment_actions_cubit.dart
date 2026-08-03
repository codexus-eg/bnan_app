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
    result.fold(
      (failure) => emit(AssignSupervisorFailure(supervisorId, failure.message)),
      (response) => emit(
        AssignSupervisorSuccess(supervisorId: supervisorId, response: response),
      ),
    );
  }

  Future<void> unassignSupervisorFromClassroom({
    required String supervisorId,
    required String classroomId,
  }) async {
    if (supervisorId.isEmpty || classroomId.isEmpty) return;
    emit(UnassignSupervisorLoading(supervisorId, classroomId));
    final result = await repo.unassignSupervisorFromClassroom(
      supervisorId: supervisorId,
      classroomId: classroomId,
    );
    result.fold(
      (failure) => emit(
        UnassignSupervisorFailure(
          supervisorId: supervisorId,
          classroomId: classroomId,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        UnassignSupervisorSuccess(
          supervisorId: supervisorId,
          classroomId: classroomId,
          response: response,
        ),
      ),
    );
  }
}
