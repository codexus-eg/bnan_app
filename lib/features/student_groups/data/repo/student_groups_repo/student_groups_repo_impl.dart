import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:bnan_app/features/student_groups/data/repo/student_groups_repo/student_groups_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class StudentGroupsRepoImpl implements StudentGroupsRepo {
  const StudentGroupsRepoImpl({
    required this.apiConsumer,
  });

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, StudentEnrollmentsResponseModel>>
      getMyEnrollments() async {
    try {
      final response = await apiConsumer.get(
        EndPoints.myEnrollments,
        isProtected: true,
      );

      return Right(StudentEnrollmentsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }
}