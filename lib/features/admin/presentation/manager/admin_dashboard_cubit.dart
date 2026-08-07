import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/admin/data/repo/admin_dashboard_repo.dart';
import 'package:bnan_app/features/admin/presentation/manager/admin_dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  AdminDashboardCubit(this.repo) : super(AdminDashboardInitial());

  final AdminDashboardRepo repo;
  AdminDashboardStatisticsModel? _statistics;
  bool _busy = false;

  AdminDashboardStatisticsModel? get statistics => _statistics;

  Future<void> load() async {
    if (_busy) return;
    _busy = true;
    final previous = _statistics;
    emit(
      previous == null
          ? AdminDashboardLoading()
          : AdminDashboardRefreshing(previous),
    );
    final result = await repo.getStatistics();
    result.fold(
      (failure) => emit(
        previous == null
            ? AdminDashboardFailure(failure.message, failure.statusCode)
            : AdminDashboardRefreshFailure(previous, failure.message),
      ),
      (statistics) {
        _statistics = statistics;
        emit(AdminDashboardSuccess(statistics));
      },
    );
    _busy = false;
  }

  Future<void> refresh() => load();
}
