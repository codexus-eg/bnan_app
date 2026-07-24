import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedule_by_classroom_cubit/get_egyptian_schedule_by_classroom_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEgyptianScheduleByClassroomCubit
    extends Cubit<GetEgyptianScheduleByClassroomState> {
  GetEgyptianScheduleByClassroomCubit(this.repo)
    : super(GetEgyptianScheduleByClassroomInitial());

  final TableManagementRepo repo;

  Future<void> getEgyptianScheduleByClassroom(String classroomId) async {
    emit(GetEgyptianScheduleByClassroomLoading());

    final result = await repo.getEgyptianScheduleByClassroom(classroomId);

    result.fold(
      (failure) => emit(GetEgyptianScheduleByClassroomFailure(failure.message)),
      (response) => emit(GetEgyptianScheduleByClassroomSuccess(response)),
    );
  }
}
