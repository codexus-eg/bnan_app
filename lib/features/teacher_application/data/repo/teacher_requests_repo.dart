import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_status_request_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeacherRequestsRepo {
Future<Either<Failure, TeacherRequestResponseModel>>
    getPendingTeacherRequests();

  Future<Either<Failure, TeacherDetailsResponseModel>> getTeacherDetails(
    String teacherId,
  );

  Future<Either<Failure, void>> updateTeacherStatus(
    String teacherId,
    TeacherStatusRequestModel model,
  );
}