import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/grades_management/data/models/create_grade_request_model.dart';
import 'package:bnan_app/features/grades_management/data/models/grades_response_model.dart';
import 'package:bnan_app/features/grades_management/data/repo/grades_repo.dart';
import 'package:dartz/dartz.dart';

class GradesRepoImpl implements GradesRepo {
  const GradesRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, GradesResponseModel>> getGrades() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.grades,
        isProtected: true,
      );

      return GradesResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, void>> createGrade(CreateGradeRequestModel model) {
    return repoGuard(() async {
      await apiConsumer.post(
        EndPoints.grades,
        data: model.toJson(),
        isProtected: true,
      );
    });
  }

  @override
  Future<Either<Failure, void>> deleteGrade(String gradeId) {
    return repoGuard(() async {
      await apiConsumer.delete(
        EndPoints.gradeById(gradeId),
        isProtected: true,
      );
    });
  }
}