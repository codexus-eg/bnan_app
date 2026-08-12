import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/student_auth/data/models/simple_response_model.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_response_model.dart';
import 'package:bnan_app/features/shared_profile/data/models/update_profile_response_model.dart';
import 'package:bnan_app/features/shared_profile/data/repo/student_profile_repo/student_profile_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class StudentProfileRepoImpl implements StudentProfileRepo {
  const StudentProfileRepoImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, LoggedUserResponseModel>> getLoggedUser() async {
    try {
      final response = await apiConsumer.get(
        EndPoints.getLoggedUser,
        isProtected: true,
      );

      return Right(LoggedUserResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, UpdateProfileResponseModel>> updateLoggedUserName({
    required String fullName,
  }) async {
    try {
      final response = await apiConsumer.patch(
        EndPoints.updateLoggedUserName,
        isProtected: true,
        data: {'fullName': fullName},
      );

      return Right(UpdateProfileResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, UpdateProfileResponseModel>> updateLoggedUserPhone({
    required String phone,
  }) async {
    try {
      final response = await apiConsumer.patch(
        EndPoints.updateLoggedUserPhone,
        isProtected: true,
        data: {'phone': phone},
      );

      return Right(UpdateProfileResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, SimpleResponseModel>> updatePassword({
    required String currentPassword,
    required String updatedPassword,
  }) async {
    try {
      final response = await apiConsumer.patch(
        EndPoints.updatePassword,
        isProtected: true,
        data: {
          'currentPassword': currentPassword,
          'updatedPassword': updatedPassword,
        },
      );

      final result = SimpleResponseModel.fromJson(response);
      if (result.hasTokenPair) {
        await SessionManager.instance.saveTokens(
          accessToken: result.token,
          refreshToken: result.refreshToken,
        );
      }
      return Right(result);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<void> logout() async {
    await SessionManager.instance.clearSession();
  }
}
