import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_request.dart';
import 'package:dartz/dartz.dart';

abstract class DiscountCodesRepo {
  Future<Either<Failure, List<DiscountCodeModel>>> getAll();
  Future<Either<Failure, DiscountCodeModel>> getById(String id);
  Future<Either<Failure, DiscountCodeModel>> create(
    DiscountCodeRequest request,
  );
  Future<Either<Failure, DiscountCodeModel>> update(
    String id,
    DiscountCodeRequest request,
  );
  Future<Either<Failure, Unit>> delete(String id);
}
