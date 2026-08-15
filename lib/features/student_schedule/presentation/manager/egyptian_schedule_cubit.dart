import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_week_policy.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EgyptianScheduleCubit extends Cubit<EgyptianScheduleState> {
  EgyptianScheduleCubit(this._repo) : super(const EgyptianScheduleState());
  final TableManagementRepo _repo;
  int _requestId = 0;

  Future<void> load({int? selectedWeek}) async {
    final requestId = ++_requestId;
    emit(state.copyWith(status: EgyptianScheduleStatus.loading, error: ''));
    final currentStart = state.week?.currentWeekStart;
    final currentWeek = state.week?.currentWeek;
    final start =
        selectedWeek == null || currentStart == null || currentWeek == null
        ? null
        : egyptianApiDate(
            egyptianWeekStart(currentStart, selectedWeek - currentWeek),
          );
    final result = await _repo.getMyEgyptianDigitalSchedule(weekStart: start);
    if (isClosed || requestId != _requestId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EgyptianScheduleStatus.failure,
          error: failure.message,
        ),
      ),
      (week) => emit(
        EgyptianScheduleState(
          status: EgyptianScheduleStatus.success,
          week: week,
          selectedWeek: selectedWeek ?? week.currentWeek,
          maxWeek: week.currentWeek == null
              ? null
              : egyptianMaxWeek(week.currentWeek!, week.timezone),
        ),
      ),
    );
  }

  void selectWeek(int week) => load(selectedWeek: week);
}
