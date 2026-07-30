import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/users_management/data/models/add_user_request_model.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/data/models/user_response_model.dart';
import 'package:bnan_app/features/users_management/data/models/users_response_model.dart';
import 'package:bnan_app/features/users_management/data/repo/users_management_repo.dart';
import 'package:dartz/dartz.dart';

class UsersManagementRepoImpl implements UsersManagementRepo {
  const UsersManagementRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, UsersResponseModel>> getUsers({
    required int page,
    String? search,
    String? role,
  }) {
    return _guard(() async {
      final response = await apiConsumer.get(
        EndPoints.users,
        queryParameter: {
          'page': page,
          if (search != null && search.isNotEmpty) 'search': search,
          if (role != null && role.isNotEmpty) 'role': role,
        },
        isProtected: true,
      );

      return UsersResponseModel.fromJson(_asMap(response));
    });
  }

  @override
  Future<Either<Failure, UserResponseModel>> getUserDetails({
    required String userId,
  }) {
    return _guard(() async {
      final response = await apiConsumer.get(
        EndPoints.userById(userId),
        isProtected: true,
      );

      return UserResponseModel.fromJson(_asMap(response));
    });
  }

  @override
  Future<Either<Failure, UserResponseModel>> createUser({
    required AddUserRequestModel request,
  }) {
    return _guard(() async {
      final response = await apiConsumer.post(
        EndPoints.users,
        data: request.toJson(),
        isProtected: true,
      );

      return UserResponseModel.fromJson(_asMap(response));
    });
  }

  @override
  Future<Either<Failure, UserResponseModel>> updateUser({
    required String userId,
    required UserItem user,
  }) {
    return _guard(() async {
      final response = await apiConsumer.patch(
        EndPoints.userById(userId),
        data: user.toUpdateJson(),
        isProtected: true,
      );

      return UserResponseModel.fromJson(_asMap(response));
    });
  }

  @override
  Future<Either<Failure, bool>> updateUserPassword({
    required String userId,
    required String password,
  }) {
    return _guard(() async {
      await apiConsumer.patch(
        EndPoints.userPassword(userId),
        data: {'password': password},
        isProtected: true,
      );

      return true;
    });
  }

  @override
  Future<Either<Failure, UserResponseModel>> updateUserStatus({
    required String userId,
    required String status,
  }) {
    return _guard(() async {
      final response = await apiConsumer.patch(
        EndPoints.userStatus(userId),
        data: {'status': status},
        isProtected: true,
      );

      return UserResponseModel.fromJson(_asMap(response));
    });
  }

  @override
  Future<Either<Failure, bool>> deleteUser({required String userId}) {
    return _guard(() async {
      await apiConsumer.delete(EndPoints.userById(userId), isProtected: true);

      return true;
    });
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Right(await request());
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (error) {
      return Left(Failure(message: error.toString()));
    }
  }

  Map<String, dynamic> _asMap(Object? response) {
    return response is Map ? Map<String, dynamic>.from(response) : {};
  }
}
