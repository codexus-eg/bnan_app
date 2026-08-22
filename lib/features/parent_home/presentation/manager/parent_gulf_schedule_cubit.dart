import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/parent_gulf_schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentGulfScheduleCubit extends Cubit<ParentGulfScheduleState> {
  ParentGulfScheduleCubit(this._repo, this.studentId)
    : super(const ParentGulfScheduleState());

  final GulfScheduleRepo _repo;
  final String studentId;
  int _requestId = 0;

  Future<void> load() async {
    final requestId = ++_requestId;
    emit(state.copyWith(status: ParentGulfScheduleStatus.loading, error: ''));
    final result = await _repo.getParentGulfSchedule(studentId: studentId);
    if (isClosed || requestId != _requestId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ParentGulfScheduleStatus.failure,
          error: failure.message,
        ),
      ),
      (response) => emit(
        ParentGulfScheduleState(
          status: ParentGulfScheduleStatus.success,
          classrooms: response.data.classrooms,
        ),
      ),
    );
  }
}
