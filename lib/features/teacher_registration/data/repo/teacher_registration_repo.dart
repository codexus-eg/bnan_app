import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_register_request_model.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_terms_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeacherRegistrationRepo {
  Future<Either<Failure, AuthResponseModel>> registerTeacher({
    required TeacherRegisterRequestModel request,
  });
}

abstract class TeacherTermsRepo {
  Future<Either<Failure, TeacherTermsModel>> getTeacherTerms();
}
