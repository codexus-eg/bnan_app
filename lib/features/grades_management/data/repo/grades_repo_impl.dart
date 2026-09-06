import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/grades_management/data/models/create_grade_request_model.dart';
import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';
import 'package:bnan_app/features/grades_management/data/models/grades_response_model.dart';
import 'package:bnan_app/features/grades_management/data/repo/grades_repo.dart';
import 'package:dartz/dartz.dart';

class GradesRepoImpl implements GradesRepo {
  const GradesRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, GradesResponseModel>> getGrades({
    int? page,
    int? limit,
  }) {
    return repoGuard(() async {
      if (page != null) {
        final response = await apiConsumer.get(
          EndPoints.grades,
          queryParameter: {
            'page': page,
            if (limit != null) 'limit': limit,
          },
          isProtected: true,
        );
        return GradesResponseModel.fromJson(asMap(response));
      }

      final initialResponse = await apiConsumer.get(
        EndPoints.grades,
        queryParameter: {'limit': limit ?? 100, 'page': 1},
        isProtected: true,
      );
      final firstPage = GradesResponseModel.fromJson(asMap(initialResponse));
      final allGrades = List<GradeModel>.from(firstPage.data);

      var currentPage = firstPage.currentPage ?? 1;
      final totalPages = firstPage.totalPages ?? 1;

      while (currentPage < totalPages) {
        currentPage++;
        final nextResponse = await apiConsumer.get(
          EndPoints.grades,
          queryParameter: {'limit': limit ?? 100, 'page': currentPage},
          isProtected: true,
        );
        final nextPage = GradesResponseModel.fromJson(asMap(nextResponse));
        allGrades.addAll(nextPage.data);
      }

      return GradesResponseModel(
        success: firstPage.success,
        length: allGrades.length,
        totalCount: firstPage.totalCount ?? allGrades.length,
        totalPages: totalPages,
        currentPage: currentPage,
        hasNextPage: false,
        data: allGrades,
      );
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