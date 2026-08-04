import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_request_model.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class SubjectsRepo {
  Future<Either<Failure, SubjectsResponseModel>> getSubjects({
    required int page,
    required int limit,
  });

  Future<Either<Failure, Unit>> addSubject({
    required AddSubjectRequestModel request,
  });

  Future<Either<Failure, Unit>> updateSubject({
    required String subjectId,
    required UpdateSubjectRequestModel request,
  });
}
