import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_response_model.dart';
import 'package:bnan_app/features/parent_auth/data/repo/parent_auth_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class ParentAuthRepoImpl implements ParentAuthRepo {
  const ParentAuthRepoImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, ParentRegisterResponseModel>> registerParent(
    ParentRegisterRequestModel request,
  ) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.registerParent,
        data: request.toJson(),
      );
      final result = ParentRegisterResponseModel.fromJson(response);
      await _saveSession(result);
      return Right(result);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  Future<void> _saveSession(ParentRegisterResponseModel response) async {
    if (!response.hasToken) return;
    await SessionManager.instance.saveSession(
      accessToken: response.token,
      refreshToken: response.refreshToken,
      userId: response.data.id,
      userRole: response.data.role,
      userName: response.data.fullName,
    );
  }
}
