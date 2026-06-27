import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/shared_profile/data/models/teacher_profile_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeacherProfileRepo {
  Future<Either<Failure, TeacherProfileResponseModel>> getTeacherProfile();
}