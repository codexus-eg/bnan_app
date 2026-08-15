import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_week_policy.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentEgyptianScheduleCubit extends Cubit<EgyptianScheduleState> {
  ParentEgyptianScheduleCubit(this._repo, this.studentId, {this.onWeekResolved})
    : super(const EgyptianScheduleState());

  final TableManagementRepo _repo;
  final String studentId;
  final void Function(int, String)? onWeekResolved;
  int _requestId = 0;
  String? _lastWeekStart;

  Future<void> load({int? selectedWeek, String? weekStart}) async {
    final requestId = ++_requestId;
    _lastWeekStart = weekStart ?? _lastWeekStart;
    emit(state.copyWith(status: EgyptianScheduleStatus.loading, error: ''));
    final result = await _repo.getParentEgyptianSchedule(
      studentId: studentId,
      weekStart: _lastWeekStart,
    );
    if (isClosed || requestId != _requestId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EgyptianScheduleStatus.failure,
          error: failure.message,
        ),
      ),
      (week) {
        final resolvedWeek = selectedWeek ?? week.currentWeek;
        final resolvedStart =
            _lastWeekStart ??
            (week.currentWeekStart == null
                ? null
                : egyptianApiDate(week.currentWeekStart!));
        if (resolvedWeek != null && resolvedStart != null) {
          onWeekResolved?.call(resolvedWeek, resolvedStart);
        }
        emit(
          EgyptianScheduleState(
            status: EgyptianScheduleStatus.success,
            week: week,
            selectedWeek: resolvedWeek,
            maxWeek: week.currentWeek == null
                ? null
                : egyptianMaxWeek(week.currentWeek!, week.timezone),
          ),
        );
      },
    );
  }

  String? weekStartFor(int week) {
    final start = state.week?.currentWeekStart;
    final current = state.week?.currentWeek;
    if (start == null || current == null) return null;
    return egyptianApiDate(egyptianWeekStart(start, week - current));
  }

  void selectWeek(int week) =>
      load(selectedWeek: week, weekStart: weekStartFor(week));
}
