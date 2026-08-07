import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';

sealed class AdminDashboardState {}

final class AdminDashboardInitial extends AdminDashboardState {}
final class AdminDashboardLoading extends AdminDashboardState {}

abstract class AdminDashboardDataState extends AdminDashboardState {
  AdminDashboardDataState(this.statistics);
  final AdminDashboardStatisticsModel statistics;
}

final class AdminDashboardSuccess extends AdminDashboardDataState {
  AdminDashboardSuccess(super.statistics);
}

final class AdminDashboardRefreshing extends AdminDashboardDataState {
  AdminDashboardRefreshing(super.statistics);
}

final class AdminDashboardFailure extends AdminDashboardState {
  AdminDashboardFailure(this.message, this.statusCode);
  final String message;
  final int? statusCode;
}

final class AdminDashboardRefreshFailure extends AdminDashboardDataState {
  AdminDashboardRefreshFailure(super.statistics, this.message);
  final String message;
}
