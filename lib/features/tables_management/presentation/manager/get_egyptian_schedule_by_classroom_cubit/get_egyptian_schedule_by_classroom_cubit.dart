import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedule_by_classroom_cubit/get_egyptian_schedule_by_classroom_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEgyptianScheduleByClassroomCubit
    extends Cubit<GetEgyptianScheduleByClassroomState> {
  GetEgyptianScheduleByClassroomCubit(this.repo)
    : super(GetEgyptianScheduleByClassroomInitial());

  final TableManagementRepo repo;

  Future<void> getEgyptianScheduleByClassroom(String classroomId) async {
    if (isClosed) return;
    emit(GetEgyptianScheduleByClassroomLoading());

    final result = await repo.getEgyptianScheduleByClassroom(classroomId);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(GetEgyptianScheduleByClassroomFailure(failure.message));
      },
      (response) {
        if (isClosed) return;
        emit(GetEgyptianScheduleByClassroomSuccess(response));
      },
    );
  }
}
