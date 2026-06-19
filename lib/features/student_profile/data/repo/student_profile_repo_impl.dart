import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/student_auth/data/models/simple_response_model.dart';
import 'package:bnan_app/features/student_profile/data/local/student_profile_local_data_source.dart';
import 'package:bnan_app/features/student_profile/data/models/logged_user_response_model.dart';
import 'package:bnan_app/features/student_profile/data/models/update_profile_response_model.dart';
import 'package:bnan_app/features/student_profile/data/repo/student_profile_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class StudentProfileRepoImpl implements StudentProfileRepo {
  const StudentProfileRepoImpl({
    required this.apiConsumer,
    required this.localDataSource,
  });
  final ApiConsumer apiConsumer;
  final StudentProfileLocalDataSource localDataSource;
  
  @override
  Future<Either<Failure, LoggedUserResponseModel>> refreshLoggedUser() async {
    try {
      final response = await apiConsumer.get(
        EndPoints.getLoggedUser,
        isProtected: true,
      );

      final loggedUserResponse = LoggedUserResponseModel.fromJson(response);

      await localDataSource.cacheLoggedUser(
        loggedUserResponse: loggedUserResponse,
      );

      return Right(loggedUserResponse);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, LoggedUserResponseModel>> getLoggedUser() async {
    final cachedUser = await localDataSource.getCachedLoggedUser();

    if (cachedUser != null) {
      return Right(cachedUser);
    }

    return await refreshLoggedUser();
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

      return Right(SimpleResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<LoggedUserResponseModel?> getCachedLoggedUser() async {
    return await localDataSource.getCachedLoggedUser();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearCachedLoggedUser();
    await SessionManager.instance.clearSession();
  }
}
