import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/admin/data/repo/admin_dashboard_repo.dart';
import 'package:dartz/dartz.dart';

class AdminDashboardRepoImpl implements AdminDashboardRepo {
  const AdminDashboardRepoImpl(this.api);
  final ApiConsumer api;

  @override
  Future<Either<Failure, AdminDashboardStatisticsModel>> getStatistics() {
    return repoGuard(() async {
      final response = await api.get(
        EndPoints.adminDashboardStatistics,
        isProtected: true,
      );
      return AdminDashboardStatisticsModel.fromResponse(response);
    });
  }
}
