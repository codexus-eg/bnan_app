import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/grades_management/data/models/grades_response_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/curriculum_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_request_model.dart';
import 'package:bnan_app/features/student_auth/data/models/simple_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/subject_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, AuthResponseModel>> register({
    required RegisterRequestModel request,
  });

  Future<Either<Failure, AuthResponseModel>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, AuthResponseModel>> loginStudentAfterPayment({
    required String email,
    required String password,
  });

  Future<Either<Failure, SimpleResponseModel>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, SimpleResponseModel>> verifyResetCode({
    required String resetCode,
  });

  Future<Either<Failure, SimpleResponseModel>> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<Either<Failure, CurriculumsResponseModel>> getAllCurriculums();
  Future<Either<Failure, PackageResponseModel>> getCurriculumPackages({
    required String curriculumId,
  });
  Future<Either<Failure, GradesResponseModel>> getCurriculumGrades({
    required String curriculumId,
  });
  Future<Either<Failure, GradesResponseModel>> getGulfCurriculumGrades({
    required String curriculumId,
  });

  Future<Either<Failure, SubjectsResponseModel>> getCurriculumSubjects({
    required String curriculumId,
    required String gradeId,
  });
  Future<Either<Failure, SubjectsResponseModel>> getGulfGradeSubjects({
    required String gradeId,
  });
}
