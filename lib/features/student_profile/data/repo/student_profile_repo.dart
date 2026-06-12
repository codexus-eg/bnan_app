import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/auth/data/models/simple_response_model.dart';
import 'package:bnan_app/features/student_profile/data/models/logged_user_response_model.dart';
import 'package:bnan_app/features/student_profile/data/models/update_profile_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudentProfileRepo {
  Future<LoggedUserResponseModel?> getCachedLoggedUser();
  Future<Either<Failure, LoggedUserResponseModel>> refreshLoggedUser();
  Future<Either<Failure, LoggedUserResponseModel>> getLoggedUser();

  Future<Either<Failure, UpdateProfileResponseModel>> updateLoggedUserName({
    required String fullName,
  });

  Future<Either<Failure, UpdateProfileResponseModel>> updateLoggedUserPhone({
    required String phone,
  });

  Future<Either<Failure, SimpleResponseModel>> updatePassword({
    required String currentPassword,
    required String updatedPassword,
  });

  Future<void> logout();
}
