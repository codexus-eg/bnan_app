import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';

sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

abstract class DashboardDataState extends DashboardState {
  DashboardDataState(this.data);
  final DashboardData data;
}

final class DashboardSuccess extends DashboardDataState {
  DashboardSuccess(super.data);
}

final class DashboardRefreshing extends DashboardDataState {
  DashboardRefreshing(super.data);
}

final class DashboardRefreshFailure extends DashboardDataState {
  DashboardRefreshFailure(super.data, this.message);
  final String message;
}

final class DashboardFailure extends DashboardState {
  DashboardFailure(this.message, this.statusCode);
  final String message;
  final int? statusCode;
}

final class DashboardSessionInvalid extends DashboardState {
  DashboardSessionInvalid(this.message);
  final String message;
}
