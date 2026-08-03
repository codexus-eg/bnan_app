import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/assign_supervisor_request_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/supervisor_assignments_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/unassign_supervisor_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class SupervisorAssignmentRepoImpl implements SupervisorAssignmentRepo {
  const SupervisorAssignmentRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, GetSupervisorsResponseModel>> getSupervisors() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.supervisors,
        isProtected: true,
      );
      return GetSupervisorsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  getSupervisorAssignments({required String supervisorId}) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.supervisorAssignments(supervisorId),
        isProtected: true,
      );
      return SupervisorAssignmentsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  assignSupervisorToClassrooms({
    required String supervisorId,
    required AssignSupervisorRequestModel request,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.post(
        EndPoints.supervisorAssignments(supervisorId),
        data: request.toJson(),
        isProtected: true,
      );
      return SupervisorAssignmentsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, UnassignSupervisorResponseModel>>
  unassignSupervisorFromClassroom({
    required String supervisorId,
    required String classroomId,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.patch(
        EndPoints.unassignSupervisorFromClassroom(
          supervisorId: supervisorId,
          classroomId: classroomId,
        ),
        isProtected: true,
      );
      return UnassignSupervisorResponseModel.fromJson(asMap(response));
    });
  }
}
