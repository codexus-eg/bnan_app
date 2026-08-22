import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/ideal_supervisor/data/models/ideal_supervisor_request.dart';
import 'package:dartz/dartz.dart';

abstract class AdminIdealSupervisorRepo {
  Future<Either<Failure, Unit>> issueIdealSupervisors(
    IdealSupervisorRequest request,
  );
}
