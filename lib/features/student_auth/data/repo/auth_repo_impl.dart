import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_keys.dart';
import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/grades_management/data/models/grades_response_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/curriculum_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_request_model.dart';
import 'package:bnan_app/features/student_auth/data/models/simple_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/subject_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

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
      return Left(Failure(message: S.current.unexpectedError));
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
        data: {'email': email, 'password': password},
      );

      final authResponse = AuthResponseModel.fromJson(response);
      await _saveSession(authResponse);

      return Right(authResponse);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
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
      return Left(Failure(message: S.current.unexpectedError));
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
      return Left(Failure(message: S.current.unexpectedError));
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
        data: {'email': email, 'newPassword': newPassword},
      );

      return Right(SimpleResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, CurriculumsResponseModel>> getAllCurriculums() async {
    try {
      final response = await apiConsumer.get(EndPoints.curriculums);

      return Right(CurriculumsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, PackageResponseModel>> getCurriculumPackages({
    required String curriculumId,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.packagesByCurriculum(curriculumId),
      );

      return Right(PackageResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, GradesResponseModel>> getCurriculumGrades({
    required String curriculumId,
  }) async {
    try {
      final response = await apiConsumer.get(
        //TODO
        EndPoints.getGrades(curriculumId: curriculumId),
      );

      return Right(GradesResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, SubjectsResponseModel>> getCurriculumSubjects({
    required String curriculumId,
    required String gradeId,
  }) async {
    try {
      final response = await apiConsumer.get(
        // TODO HERE
        EndPoints.curriculumSubjects(
          curriculumId: '6a1b56274fdcd300239c9877',
          gradeId: gradeId,
        ),
      );

      return Right(SubjectsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  Future<void> _saveSession(AuthResponseModel authResponse) async {
    if (!authResponse.hasToken) return;
    debugPrint(
      'Student login token received: ${authResponse.token.isNotEmpty}',
    );

    await SessionManager.instance.saveSession(
      accessToken: authResponse.token,
      refreshToken: '',
      userId: authResponse.user.id,
      userRole: authResponse.user.role,
    );

    final storedToken = await SecureCacheHelper.getData(
      key: SecureCacheKeys.accessToken,
    );
    debugPrint(
      'Token stored after student login: '
      '${storedToken != null && storedToken.isNotEmpty}',
    );
  }
}
