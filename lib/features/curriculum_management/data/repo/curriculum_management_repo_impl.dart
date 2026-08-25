import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/curriculum_management/data/models/create_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculums_response_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/update_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/data/repo/curriculum_management_repo.dart';
import 'package:dartz/dartz.dart';

class CurriculumManagementRepoImpl implements CurriculumManagementRepo {
  const CurriculumManagementRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, CurriculumsResponseModel>> getCurriculums() {
    return repoGuard(() async {
      final response = await apiConsumer.get(EndPoints.curriculums);
      return CurriculumsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, CurriculumModel>> createCurriculum(
    CreateCurriculumRequestModel request,
  ) {
    return repoGuard(() async {
      final response = await apiConsumer.post(
        EndPoints.curriculums,
        data: await request.toFormData(),
        isFormData: true,
        isProtected: true,
      );

      return _curriculumFromResponse(response);
    });
  }

  @override
  Future<Either<Failure, CurriculumModel>> updateCurriculum({
    required String curriculumId,
    required UpdateCurriculumRequestModel request,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.patch(
        EndPoints.updateCurriculum(curriculumId),
        data: await request.toFormData(),
        isFormData: true,
        isProtected: true,
      );

      return _curriculumFromResponse(response);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteCurriculum(String curriculumId) {
    return repoGuard(() async {
      await apiConsumer.delete(
        EndPoints.updateCurriculum(curriculumId),
        isProtected: true,
      );
      return unit;
    });
  }

  CurriculumModel _curriculumFromResponse(Object? response) {
    final data = asMap(response)['data'];
    return CurriculumModel.fromJson(
      data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
    );
  }
}
