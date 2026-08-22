import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/errors/read_evaluations_failure_mapper.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

Future<Either<Failure, T>> readEvaluationsRepoGuard<T>(
  Future<T> Function() request,
) async {
  try {
    return Right(await request());
  } on AppException catch (error) {
    return Left(
      Failure(
        message: ReadEvaluationsFailureMapper.map(
          message: error.message,
          code: error.code,
          statusCode: error.statusCode,
        ),
        responseReceived: error.responseReceived,
        statusCode: error.statusCode,
        code: error.code,
      ),
    );
  } catch (_) {
    return Left(Failure(message: S.current.unexpectedError));
  }
}
