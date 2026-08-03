import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_request_model.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:dartz/dartz.dart';

class SubjectsRepoImpl implements SubjectsRepo {
  final ApiConsumer apiConsumer;

  SubjectsRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, SubjectsResponseModel>> getSubjects() {
    return repoGuard(() async {
      final response = await apiConsumer.get(EndPoints.subjects);
      return SubjectsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, Unit>> addSubject({
    required AddSubjectRequestModel request,
  }) {
    return repoGuard(() async {
      await apiConsumer.post(
        EndPoints.subjects,
        data: request.toJson(),
        isProtected: true,
      );

      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> updateSubject({
    required String subjectId,
    required UpdateSubjectRequestModel request,
  }) {
    return repoGuard(() async {
      await apiConsumer.patch(
        EndPoints.subjectById(subjectId),
        data: request.toJson(),
        isProtected: true,
      );

      return unit;
    });
  }
}
