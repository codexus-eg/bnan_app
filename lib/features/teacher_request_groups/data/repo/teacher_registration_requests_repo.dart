import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/accepted_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeacherRegistrationRequestsRepo {
  Future<Either<Failure, TeacherRequestsResponseModel>> getRequests({
    required int page,
    int limit = 20,
  });

  Future<Either<Failure, AcceptedTeacherRequestModel>> acceptRequest(
    String requestId,
  );
}
