import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_response_model.dart';
import 'package:dartz/dartz.dart';

abstract interface class ParentAuthRepo {
  Future<Either<Failure, ParentRegisterResponseModel>> registerParent(
    ParentRegisterRequestModel request,
  );
}
