import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/repo/dashboard_repo.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_state.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/diagnostics/gulf_renewal_trace.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.repo, this.expectedRole) : super(DashboardInitial());
  final DashboardRepo repo;
  final DashboardRole expectedRole;
  DashboardData? _data;
  bool _busy = false;

  Future<void> load() async {
    if (_busy || isClosed) return;
    _busy = true;
    GulfRenewalTrace.log('dashboard refresh started');
    final previous = _data;
    emit(previous == null ? DashboardLoading() : DashboardRefreshing(previous));
    final result = await repo.getDashboard();
    if (isClosed) return;
    result.fold(
      (failure) => _emitFailure(previous, failure.message, failure.statusCode),
      (data) {
        if (data.role != expectedRole) {
          return _emitFailure(previous, 'Invalid dashboard role', 403);
        }
        _data = data;
        emit(DashboardSuccess(data));
      },
    );
    _busy = false;
    GulfRenewalTrace.log('dashboard refresh finished');
  }

  void _emitFailure(DashboardData? old, String message, int? code) {
    emit(
      old == null
          ? DashboardFailure(message, code)
          : DashboardRefreshFailure(old, message),
    );
  }

  Future<void> refresh() => load();
}
