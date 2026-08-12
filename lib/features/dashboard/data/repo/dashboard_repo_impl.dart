import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_response.dart';
import 'package:bnan_app/features/dashboard/data/repo/dashboard_repo.dart';

class DashboardRepoImpl implements DashboardRepo {
  const DashboardRepoImpl(this.api);
  final ApiConsumer api;

  @override
  getDashboard() => repoGuard(() async {
    final response = await api.get(EndPoints.dashboard, isProtected: true);
    return DashboardResponse.parse(response);
  });
}
