import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEgyptianSchedulesCubit extends Cubit<GetEgyptianSchedulesState> {
  GetEgyptianSchedulesCubit(this.repo) : super(GetEgyptianSchedulesInitial());

  final TableManagementRepo repo;

  Future<void> getEgyptianSchedules({String? gradeId}) async {
    emit(GetEgyptianSchedulesLoading());

    final result = await repo.getEgyptianSchedules(gradeId: gradeId);

    result.fold(
      (failure) => emit(GetEgyptianSchedulesFailure(failure.message)),
      (response) => emit(GetEgyptianSchedulesSuccess(response)),
    );
  }
}
