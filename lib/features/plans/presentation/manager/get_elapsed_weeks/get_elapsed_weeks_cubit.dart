import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_elapsed_weeks/get_elapsed_weeks_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetElapsedWeeksCubit extends Cubit<GetElapsedWeeksState> {
  GetElapsedWeeksCubit(this.plansRepo) : super(GetElapsedWeeksInitial());

  final PlansRepo plansRepo;
  String? _activeClassroomId;
  int _requestId = 0;

  Future<void> getElapsedWeeks({required String classroomId}) async {
    _activeClassroomId = classroomId;
    final requestId = ++_requestId;
    emit(GetElapsedWeeksLoading());

    final result = await plansRepo.getElapsedWeeks(classroomId: classroomId);
    if (isClosed ||
        requestId != _requestId ||
        _activeClassroomId != classroomId) {
      return;
    }

    result.fold(
      (failure) => emit(GetElapsedWeeksFailure(failure.message)),
      (response) => emit(GetElapsedWeeksSuccess(response)),
    );
  }
}
