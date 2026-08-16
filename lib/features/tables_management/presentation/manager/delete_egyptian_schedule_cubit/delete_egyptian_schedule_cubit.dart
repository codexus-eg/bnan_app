import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/delete_egyptian_schedule_cubit/delete_egyptian_schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteEgyptianScheduleCubit extends Cubit<DeleteEgyptianScheduleState> {
  DeleteEgyptianScheduleCubit(this.repo)
    : super(DeleteEgyptianScheduleInitial());

  final TableManagementRepo repo;

  Future<void> deleteEgyptianSchedule(String scheduleId) async {
    if (isClosed) return;
    emit(DeleteEgyptianScheduleLoading());

    final result = await repo.deleteEgyptianSchedule(scheduleId);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(DeleteEgyptianScheduleFailure(failure.message));
      },
      (_) {
        if (isClosed) return;
        emit(DeleteEgyptianScheduleSuccess());
      },
    );
  }
}
