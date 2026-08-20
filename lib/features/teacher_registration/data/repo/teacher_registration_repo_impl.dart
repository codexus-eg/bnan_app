import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_register_request_model.dart';
import 'package:bnan_app/features/teacher_registration/data/repo/teacher_registration_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class TeacherRegistrationRepoImpl implements TeacherRegistrationRepo {
  const TeacherRegistrationRepoImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, AuthResponseModel>> registerTeacher({
    required TeacherRegisterRequestModel request,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.registerTeacher,
        data: await request.toFormData(),
      );

      final authResponse = AuthResponseModel.fromJson(response);
      return Right(authResponse);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }
}
