import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/debug/gulf_registration_diagnostics.dart';
import 'package:dartz/dartz.dart';

abstract class GulfParentAuthRepo {
  Future<Either<Failure, AuthResponseModel>> authenticate(
    RegisterParentModel request,
  );
}

class GulfParentAuthRepoImpl implements GulfParentAuthRepo {
  const GulfParentAuthRepoImpl(this.api);

  final ApiConsumer api;

  @override
  Future<Either<Failure, AuthResponseModel>> authenticate(
    RegisterParentModel request,
  ) async {
    try {
      GulfRegistrationDiagnostics.started(EndPoints.login);
      final response = await api.post(
        EndPoints.login,
        data: {'email': request.email, 'password': request.password},
      );
      GulfRegistrationDiagnostics.succeeded(EndPoints.login);
      return _validateAndSave(AuthResponseModel.fromJson(response));
    } on AppException catch (error) {
      GulfRegistrationDiagnostics.failed(EndPoints.login, error);
      return Left(
        Failure(
          message: error.message,
          responseReceived: error.responseReceived,
          statusCode: error.statusCode,
          code: error.code,
        ),
      );
    } catch (error) {
      GulfRegistrationDiagnostics.failed(
        GulfRegistrationDiagnostics.lastEndpoint ?? 'parent-authentication',
        error,
      );
      return Left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, AuthResponseModel>> _validateAndSave(
    AuthResponseModel response,
  ) async {
    final role = response.user.role.trim().toLowerCase();
    final status = response.user.status.trim().toLowerCase();
    if (role != 'parent') {
      return Left(
        Failure(message: 'Invalid parent account', code: 'INVALID_PARENT_ROLE'),
      );
    }
    if (!response.hasToken || status != 'active') {
      return Left(
        Failure(
          message: 'Parent account is not active',
          code: 'ACCOUNT_NOT_VERIFIED',
        ),
      );
    }
    await SessionManager.instance.saveSession(
      accessToken: response.token,
      refreshToken: response.refreshToken,
      userId: response.user.id,
      userRole: response.user.role,
      userName: response.user.fullName,
      userEmail: response.user.email,
      userPhone: response.user.phone,
    );
    return Right(response);
  }
}
