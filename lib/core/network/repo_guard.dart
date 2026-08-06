import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

Future<Either<Failure, T>> repoGuard<T>(Future<T> Function() request) async {
  try {
    return Right(await request());
  } on AppException catch (error) {
    return Left(
      Failure(
        message: error.message,
        responseReceived: error.responseReceived,
        statusCode: error.statusCode,
      ),
    );
  } catch (error) {
    return Left(Failure(message: error.toString()));
  }
}

Map<String, dynamic> asMap(Object? response) {
  if (response is Map) return Map<String, dynamic>.from(response);
  throw Failure(message: 'Invalid response format');
}
