import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/accepted_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_response_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/repo/teacher_registration_requests_repo.dart';
import 'package:dartz/dartz.dart';

class TeacherRegistrationRequestsRepoImpl
    implements TeacherRegistrationRequestsRepo {
  const TeacherRegistrationRequestsRepoImpl(this.api);
  final ApiConsumer api;

  @override
  Future<Either<Failure, TeacherRequestsResponseModel>> getRequests({
    required int page,
    int limit = 20,
  }) => repoGuard(() async {
    final response = await api.get(
      EndPoints.gulfTeacherRequests,
      queryParameter: {'page': page, 'limit': limit},
      isProtected: true,
    );
    return TeacherRequestsResponseModel.fromJson(asMap(response));
  });

  @override
  Future<Either<Failure, AcceptedTeacherRequestModel>> acceptRequest(
    String requestId,
  ) => repoGuard(() async {
    final response = await api.patch(
      EndPoints.acceptGulfTeacherRequest(requestId),
      isProtected: true,
    );
    return AcceptedTeacherRequestModel.fromJson(asMap(response));
  });
}
