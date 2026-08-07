import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/admin/presentation/manager/admin_dashboard_cubit.dart';
import 'package:bnan_app/features/admin/presentation/manager/admin_dashboard_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'admin_dashboard_test_data.dart';
import 'fake_admin_dashboard_repo.dart';

void main() {
  test('initial load emits success with API data', () async {
    final repo = FakeAdminDashboardRepo()
      ..results.add(Right(dashboardStatistics()));
    final cubit = AdminDashboardCubit(repo);

    final future = cubit.load();
    expect(cubit.state, isA<AdminDashboardLoading>());
    await future;

    expect(cubit.state, isA<AdminDashboardSuccess>());
    expect(cubit.statistics?.totalStudents, 29);
  });

  test('initial failure has no fake zero success', () async {
    final repo = FakeAdminDashboardRepo()
      ..results.add(Left(Failure(message: 'failed')));
    final cubit = AdminDashboardCubit(repo);

    await cubit.load();

    expect(cubit.state, isA<AdminDashboardFailure>());
    expect(cubit.statistics, isNull);
  });

  test('refresh failure retains previous statistics', () async {
    final repo = FakeAdminDashboardRepo()
      ..results.add(Right(dashboardStatistics()))
      ..results.add(Left(Failure(message: 'refresh failed')));
    final cubit = AdminDashboardCubit(repo);
    await cubit.load();

    await cubit.refresh();

    final state = cubit.state as AdminDashboardRefreshFailure;
    expect(state.statistics.totalStudents, 29);
    expect(cubit.statistics?.totalStudents, 29);
  });

  test('refresh success replaces previous statistics', () async {
    const updated = AdminDashboardStatisticsModel(totalStudents: 31);
    final repo = FakeAdminDashboardRepo()
      ..results.add(Right(dashboardStatistics()))
      ..results.add(const Right(updated));
    final cubit = AdminDashboardCubit(repo);
    await cubit.load();

    await cubit.refresh();

    expect(cubit.state, isA<AdminDashboardSuccess>());
    expect(cubit.statistics?.totalStudents, 31);
  });
}
