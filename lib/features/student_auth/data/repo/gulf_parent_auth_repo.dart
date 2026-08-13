import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class GulfParentAuthRepo {
  Future<Either<Failure, AuthResponseModel>> authenticate(
    ParentRegisterRequestModel request,
  );
}

class GulfParentAuthRepoImpl implements GulfParentAuthRepo {
  const GulfParentAuthRepoImpl(this.api);

  final ApiConsumer api;

  @override
  Future<Either<Failure, AuthResponseModel>> authenticate(
    ParentRegisterRequestModel request,
  ) async {
    try {
      try {
        final response = await api.post(
          EndPoints.login,
          data: {'email': request.email, 'password': request.password},
        );
        return _validateSaveAndSync(
          AuthResponseModel.fromJson(response),
          request.phone,
        );
      } on AppException {
        final response = await api.post(
          EndPoints.registerParent,
          data: request.toJson(),
        );
        return _validateAndSave(AuthResponseModel.fromJson(response));
      }
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (error) {
      return Left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, AuthResponseModel>> _validateAndSave(
    AuthResponseModel response,
  ) async {
    final role = response.user.role.trim().toLowerCase();
    final status = response.user.status.trim().toLowerCase();
    if (!response.hasToken || role != 'parent' || status != 'active') {
      return Left(Failure(message: 'Parent account is not active'));
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

  Future<Either<Failure, AuthResponseModel>> _validateSaveAndSync(
    AuthResponseModel response,
    String phone,
  ) async {
    final validated = await _validateAndSave(response);
    if (validated.isLeft()) return validated;
    await api.patch(
      EndPoints.updateLoggedUserPhone,
      data: {'phone': phone},
      isProtected: true,
    );
    return validated;
  }
}
