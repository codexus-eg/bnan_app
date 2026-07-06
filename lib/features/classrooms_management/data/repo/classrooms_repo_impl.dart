import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_details_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classrooms_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:dartz/dartz.dart';

class ClassroomsRepoImpl implements ClassroomsRepo {
  const ClassroomsRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, ClassroomsResponseModel>> getClassrooms() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.classrooms,
        isProtected: true,
      );
      return ClassroomsResponseModel.fromJson(asMap(response));
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
