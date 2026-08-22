import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_state.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentEgyptianScheduleCubit extends Cubit<EgyptianScheduleState> {
  ParentEgyptianScheduleCubit(this._repo, this.studentId)
    : super(const EgyptianScheduleState());

  final TableManagementRepo _repo;
  final String studentId;
  int _requestId = 0;

  Future<void> load() async {
    final requestId = ++_requestId;
    emit(state.copyWith(status: EgyptianScheduleStatus.loading, error: ''));
    final result = await _repo.getParentEgyptianSchedule(studentId: studentId);
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
        ),
      ),
    );
  }
}
