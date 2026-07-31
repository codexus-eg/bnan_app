import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/supervisor_management/data/models/get_supervisor_classrooms_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class SupervisorManagementRepo {
  Future<Either<Failure, GetSupervisorClassroomsResponseModel>>
  getMyClassrooms();
}
