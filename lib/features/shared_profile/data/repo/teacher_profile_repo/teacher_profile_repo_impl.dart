import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/shared_profile/data/models/teacher_profile_response_model.dart';
import 'package:bnan_app/features/shared_profile/data/repo/teacher_profile_repo/teacher_profile_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class TeacherProfileRepoImpl implements TeacherProfileRepo {
  const TeacherProfileRepoImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, TeacherProfileResponseModel>>
      getTeacherProfile() async {
    try {
      final response = await apiConsumer.get(
        EndPoints.teacherProfile,
        isProtected: true,
      );

      return Right(TeacherProfileResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }
}