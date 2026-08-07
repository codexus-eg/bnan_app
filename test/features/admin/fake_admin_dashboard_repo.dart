import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/admin/data/repo/admin_dashboard_repo.dart';
import 'package:dartz/dartz.dart';

class FakeAdminDashboardRepo implements AdminDashboardRepo {
  final results =
      <Either<Failure, AdminDashboardStatisticsModel>>[];
  int calls = 0;

  @override
  Future<Either<Failure, AdminDashboardStatisticsModel>> getStatistics() async {
    return results[calls++];
  }
}
