import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/auth/data/models/register_request_model.dart';
import 'package:bnan_app/features/auth/data/models/simple_response_model.dart';
import 'package:bnan_app/features/auth/data/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, AuthResponseModel>> register({
    required RegisterRequestModel request,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.register,
        data: request.toJson(),
      );

      final authResponse = AuthResponseModel.fromJson(response);
      await _saveSession(authResponse);

      return Right(authResponse);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response);
      await _saveSession(authResponse);

      return Right(authResponse);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, SimpleResponseModel>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.forgotPassword,
        data: {'email': email},
      );

      return Right(SimpleResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, SimpleResponseModel>> verifyResetCode({
    required String resetCode,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.verifyResetCode,
        data: {'resetCode': resetCode},
      );

      return Right(SimpleResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, SimpleResponseModel>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.resetPassword,
        data: {
          'email': email,
          'newPassword': newPassword,
        },
      );

      return Right(SimpleResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
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
      return Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> _saveSession(AuthResponseModel authResponse) async {
    if (!authResponse.hasToken) return;

    await SessionManager.instance.saveSession(
      accessToken: authResponse.token,
      refreshToken: '',
      userId: authResponse.user.id,
      userRole: authResponse.user.role,
    );
  }
}