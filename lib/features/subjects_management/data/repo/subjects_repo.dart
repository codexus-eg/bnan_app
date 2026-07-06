import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_request_model.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class SubjectsRepo {
  Future<Either<Failure, SubjectsResponseModel>> getSubjects();

  Future<Either<Failure, Unit>> addSubject({
    required SubjectRequestModel request,
  });

  Future<Either<Failure, Unit>> updateSubject({
    required String subjectId,
    required SubjectRequestModel request,
  });
}