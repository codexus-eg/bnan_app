import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:dartz/dartz.dart';

abstract class AdminDashboardRepo {
  Future<Either<Failure, AdminDashboardStatisticsModel>> getStatistics();
}
