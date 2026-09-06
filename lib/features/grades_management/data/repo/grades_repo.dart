import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/grades_management/data/models/create_grade_request_model.dart';
import 'package:bnan_app/features/grades_management/data/models/grades_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class GradesRepo {
  Future<Either<Failure, GradesResponseModel>> getGrades({
    int? page,
    int? limit,
  });

  Future<Either<Failure, void>> createGrade(CreateGradeRequestModel model);

  Future<Either<Failure, void>> deleteGrade(String gradeId);
}