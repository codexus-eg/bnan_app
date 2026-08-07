import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/admin/data/repo/admin_dashboard_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fake_admin_dashboard_api.dart';

void main() {
  test('repository sends protected statistics request', () async {
    final api = FakeAdminDashboardApi();
    final result = await AdminDashboardRepoImpl(api).getStatistics();

    expect(result.isRight(), isTrue);
    expect(api.path, EndPoints.adminDashboardStatistics);
    expect(api.protected, isTrue);
  });

  test('repository maps API exceptions to failure', () async {
    final result = await AdminDashboardRepoImpl(
      FakeAdminDashboardApi(fail: true),
    ).getStatistics();

    expect(result.isLeft(), isTrue);
  });
}
