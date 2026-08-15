import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/parent_gulf_schedule_state.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_week_policy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentGulfScheduleCubit extends Cubit<ParentGulfScheduleState> {
  ParentGulfScheduleCubit(this._repo, this.studentId, {this.onWeekResolved})
    : super(const ParentGulfScheduleState());

  final GulfScheduleRepo _repo;
  final String studentId;
  final void Function(int, String)? onWeekResolved;
  int _requestId = 0;
  String? _lastWeekStart;

  Future<void> load({int? selectedWeek, String? weekStart}) async {
    final requestId = ++_requestId;
    _lastWeekStart = weekStart ?? _lastWeekStart;
    emit(state.copyWith(status: ParentGulfScheduleStatus.loading, error: ''));
    final result = await _repo.getParentGulfSchedule(
      studentId: studentId,
      weekStart: _lastWeekStart,
    );
    if (isClosed || requestId != _requestId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ParentGulfScheduleStatus.failure,
          error: failure.message,
        ),
      ),
      (response) {
        final data = response.data;
        final resolvedWeek = selectedWeek ?? data.currentWeek;
        final resolvedStart =
            _lastWeekStart ??
            (data.currentWeekStart == null
                ? null
                : egyptianApiDate(data.currentWeekStart!));
        if (resolvedWeek != null && resolvedStart != null) {
          onWeekResolved?.call(resolvedWeek, resolvedStart);
        }
        emit(
          ParentGulfScheduleState(
            status: ParentGulfScheduleStatus.success,
            classrooms: data.classrooms,
            currentWeek: data.currentWeek,
            currentWeekStart: data.currentWeekStart,
            timezone: data.timezone,
            selectedWeek: resolvedWeek,
            maxWeek: data.currentWeek == null
                ? null
                : egyptianMaxWeek(data.currentWeek!, data.timezone),
          ),
        );
      },
    );
  }

  String? weekStartFor(int week) {
    final start = state.currentWeekStart;
    final current = state.currentWeek;
    if (start == null || current == null) return null;
    return egyptianApiDate(egyptianWeekStart(start, week - current));
  }

  void selectWeek(int week) =>
      load(selectedWeek: week, weekStart: weekStartFor(week));
}
