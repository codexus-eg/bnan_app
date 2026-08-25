import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/curriculum_management/data/models/create_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculums_response_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/update_curriculum_request_model.dart';
import 'package:dartz/dartz.dart';

abstract class CurriculumManagementRepo {
  Future<Either<Failure, CurriculumsResponseModel>> getCurriculums();

  Future<Either<Failure, CurriculumModel>> createCurriculum(
    CreateCurriculumRequestModel request,
  );

  Future<Either<Failure, CurriculumModel>> updateCurriculum({
    required String curriculumId,
    required UpdateCurriculumRequestModel request,
  });

  Future<Either<Failure, Unit>> deleteCurriculum(String curriculumId);
}
