import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
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
      return Right(result);
    } on AppException catch (error) {
      return Left(
        Failure(
          message: error.message,
          responseReceived: error.responseReceived,
          statusCode: error.statusCode,
          code: error.code,
        ),
      );
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }
}
