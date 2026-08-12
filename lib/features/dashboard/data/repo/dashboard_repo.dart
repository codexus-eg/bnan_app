import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepo {
  Future<Either<Failure, DashboardData>> getDashboard();
}
