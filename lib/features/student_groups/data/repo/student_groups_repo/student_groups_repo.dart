import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudentGroupsRepo {
  Future<Either<Failure, StudentEnrollmentsResponseModel>> getMyEnrollments();
}