import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/data/models/user_response_model.dart';
import 'package:bnan_app/features/users_management/data/models/users_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class UsersManagementRepo {
  Future<Either<Failure, UsersResponseModel>> getUsers();

  Future<Either<Failure, UserResponseModel>> getUserDetails({
    required String userId,
  });

  Future<Either<Failure, UserResponseModel>> createUser({
    required UserItem user,
    required String password,
  });

  Future<Either<Failure, UserResponseModel>> updateUser({
    required String userId,
    required UserItem user,
  });

  Future<Either<Failure, bool>> updateUserPassword({
    required String userId,
    required String password,
  });

  Future<Either<Failure, UserResponseModel>> updateUserStatus({
    required String userId,
    required String status,
  });

  Future<Either<Failure, bool>> deleteUser({
    required String userId,
  });
}
