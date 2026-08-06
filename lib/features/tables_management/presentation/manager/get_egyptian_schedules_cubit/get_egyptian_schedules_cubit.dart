import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEgyptianSchedulesCubit extends Cubit<GetEgyptianSchedulesState> {
  GetEgyptianSchedulesCubit(this.repo, {this.studentId})
    : super(GetEgyptianSchedulesInitial());

  final TableManagementRepo repo;
  final String? studentId;
  int _requestId = 0;

  Future<void> getEgyptianSchedules({String? gradeId}) async {
    emit(GetEgyptianSchedulesLoading());

    final result = await repo.getEgyptianSchedules(gradeId: gradeId);

    result.fold(
      (failure) => emit(GetEgyptianSchedulesFailure(failure.message)),
      _emitResponse,
    );
  }

  Future<void> getMyEgyptianSchedule() async {
    final requestId = ++_requestId;
    emit(GetEgyptianSchedulesLoading());

    final result = await repo.getMyEgyptianSchedule(studentId: studentId);
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (failure) => emit(GetEgyptianSchedulesFailure(failure.message)),
      _emitResponse,
    );
  }

  void _emitResponse(EgyptianSchedulesResponseModel response) => emit(
    response.schedules.isEmpty
        ? GetEgyptianSchedulesEmpty()
        : GetEgyptianSchedulesSuccess(response),
  );

  @override
  Future<void> close() {
    _requestId++;
    return super.close();
  }
}
