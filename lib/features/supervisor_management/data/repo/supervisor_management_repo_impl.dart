import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/supervisor_management/data/models/get_supervisor_classrooms_response_model.dart';
import 'package:bnan_app/features/supervisor_management/data/repo/supervisor_management_repo.dart';
import 'package:dartz/dartz.dart';

class SupervisorManagementRepoImpl implements SupervisorManagementRepo {
  const SupervisorManagementRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, GetSupervisorClassroomsResponseModel>>
  getMyClassrooms() {
    return repoGuard(() async {
      final endpoint = SessionManager.instance.role == UserRole.teacher
          ? EndPoints.teacherClassrooms
          : EndPoints.supervisorMyClassrooms;
      final response = await apiConsumer.get(
        endpoint,
        isProtected: true,
      );
      return GetSupervisorClassroomsResponseModel.fromJson(asMap(response));
    });
  }
}
