import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_details_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classrooms_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:dartz/dartz.dart';

class ClassroomsRepoImpl implements ClassroomsRepo {
  const ClassroomsRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, ClassroomsResponseModel>> getClassrooms({
    int? page,
    int? limit,
    String? curriculum,
  }) {
    return repoGuard(() async {
      if (page != null) {
        final response = await apiConsumer.get(
          EndPoints.classrooms,
          queryParameter: {
            'page': page,
            if (limit != null) 'limit': limit,
            if (curriculum != null && curriculum.isNotEmpty)
              'curriculum': curriculum,
          },
          isProtected: true,
        );
        return ClassroomsResponseModel.fromJson(asMap(response));
      }

      final initialResponse = await apiConsumer.get(
        EndPoints.classrooms,
        queryParameter: {
          'limit': limit ?? 100,
          'page': 1,
          if (curriculum != null && curriculum.isNotEmpty)
            'curriculum': curriculum,
        },
        isProtected: true,
      );
      final firstPage = ClassroomsResponseModel.fromJson(
        asMap(initialResponse),
      );
      final allClassrooms = List<ClassroomModel>.from(firstPage.data);
      final seenIds = allClassrooms.map((c) => c.id).toSet();

      var currentPage = firstPage.pagination.currentPage > 0
          ? firstPage.pagination.currentPage
          : 1;
      final lastPage = firstPage.pagination.lastPage > 0
          ? firstPage.pagination.lastPage
          : 1;

      while (currentPage < lastPage) {
        currentPage++;
        final nextResponse = await apiConsumer.get(
          EndPoints.classrooms,
          queryParameter: {
            'limit': limit ?? 100,
            'page': currentPage,
            if (curriculum != null && curriculum.isNotEmpty)
              'curriculum': curriculum,
          },
          isProtected: true,
        );
        final nextPage = ClassroomsResponseModel.fromJson(asMap(nextResponse));
        for (final item in nextPage.data) {
          if (item.id.isNotEmpty && !seenIds.contains(item.id)) {
            seenIds.add(item.id);
            allClassrooms.add(item);
          } else if (item.id.isEmpty) {
            allClassrooms.add(item);
          }
        }
      }

      return ClassroomsResponseModel(
        success: firstPage.success,
        results: allClassrooms.length,
        pagination: ClassroomsPaginationModel(
          currentPage: currentPage,
          perPage: firstPage.pagination.perPage,
          total: allClassrooms.length,
          lastPage: lastPage,
        ),
        data: allClassrooms,
      );
    });
  }

  @override
  Future<Either<Failure, ClassroomDetailsResponseModel>> getClassroomDetails(
    String classroomId,
  ) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.getClassroom(classroomId),
        isProtected: true,
      );
      return ClassroomDetailsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, void>> createClassroom(ClassroomRequestModel model) {
    return repoGuard(() async {
      await apiConsumer.post(
        EndPoints.createClassroom,
        data: model.toJson(),
        isProtected: true,
      );
    });
  }

  @override
  Future<Either<Failure, void>> updateClassroom(
    String classroomId,
    ClassroomRequestModel model,
  ) {
    return repoGuard(() async {
      await apiConsumer.patch(
        EndPoints.updateClassroom(classroomId),
        data: model.toJson(),
        isProtected: true,
      );
    });
  }
}
