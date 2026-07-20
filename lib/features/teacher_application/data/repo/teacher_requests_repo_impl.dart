import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_status_request_model.dart';
import 'package:bnan_app/features/teacher_application/data/repo/teacher_requests_repo.dart';
import 'package:dartz/dartz.dart';

class TeacherRequestsRepoImpl implements TeacherRequestsRepo {
  const TeacherRequestsRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;
  @override
  Future<Either<Failure, TeacherRequestResponseModel>>
  getPendingTeacherRequests() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.teachersByStatus('pending'),
        isProtected: true,
      );
      return TeacherRequestResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, TeacherDetailsResponseModel>> getTeacherDetails(
    String teacherId,
  ) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.teacherById(teacherId),
        isProtected: true,
      );
      return TeacherDetailsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, void>> updateTeacherStatus(
    String teacherId,
    TeacherStatusRequestModel model,
  ) {
    return repoGuard(() async {
      await apiConsumer.patch(
        EndPoints.teacherStatus(teacherId),
        data: model.toJson(),
        isProtected: true,
      );
    });
  }
}
