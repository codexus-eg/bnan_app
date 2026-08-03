import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/assign_supervisor_request_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/supervisor_assignments_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/unassign_supervisor_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class SupervisorAssignmentRepo {
  Future<Either<Failure, GetSupervisorsResponseModel>> getSupervisors();

  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  getSupervisorAssignments({required String supervisorId});

  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  assignSupervisorToClassrooms({
    required String supervisorId,
    required AssignSupervisorRequestModel request,
  });

  Future<Either<Failure, UnassignSupervisorResponseModel>>
  unassignSupervisorFromClassroom({
    required String supervisorId,
    required String classroomId,
  });
}
