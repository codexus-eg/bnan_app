import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/supervisor_assignments_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/unassign_supervisor_response_model.dart';

sealed class SupervisorAssignmentActionsState {
  const SupervisorAssignmentActionsState();
}

final class SupervisorAssignmentActionsInitial
    extends SupervisorAssignmentActionsState {
  const SupervisorAssignmentActionsInitial();
}

final class AssignSupervisorLoading extends SupervisorAssignmentActionsState {
  const AssignSupervisorLoading(this.supervisorId);
  final String supervisorId;
}

final class AssignSupervisorSuccess extends SupervisorAssignmentActionsState {
  const AssignSupervisorSuccess({
    required this.supervisorId,
    required this.response,
  });
  final String supervisorId;
  final SupervisorAssignmentsResponseModel response;
}

final class AssignSupervisorFailure extends SupervisorAssignmentActionsState {
  const AssignSupervisorFailure(this.supervisorId, this.errorMessage);
  final String supervisorId;
  final String errorMessage;
}

final class UnassignSupervisorLoading extends SupervisorAssignmentActionsState {
  const UnassignSupervisorLoading(this.supervisorId, this.classroomId);
  final String supervisorId;
  final String classroomId;
}

final class UnassignSupervisorSuccess extends SupervisorAssignmentActionsState {
  const UnassignSupervisorSuccess({
    required this.supervisorId,
    required this.classroomId,
    required this.response,
  });
  final String supervisorId;
  final String classroomId;
  final UnassignSupervisorResponseModel response;
}

final class UnassignSupervisorFailure extends SupervisorAssignmentActionsState {
  const UnassignSupervisorFailure({
    required this.supervisorId,
    required this.classroomId,
    required this.errorMessage,
  });
  final String supervisorId;
  final String classroomId;
  final String errorMessage;
}
