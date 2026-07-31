import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_weekly_plans/get_weekly_plans_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetWeeklyPlansCubit extends Cubit<GetWeeklyPlansState> {
  GetWeeklyPlansCubit(this.plansRepo) : super(GetWeeklyPlansInitial());

  final PlansRepo plansRepo;
  String? _activeClassroomId;
  int? _activeWeek;
  int _requestId = 0;

  Future<void> getPlansByWeek({
    required String classroomId,
    required int week,
  }) async {
    _activeClassroomId = classroomId;
    _activeWeek = week;
    final requestId = ++_requestId;
    emit(GetWeeklyPlansLoading());

    final result = await plansRepo.getPlansByWeek(
      classroomId: classroomId,
      week: week,
    );
    if (isClosed ||
        requestId != _requestId ||
        _activeClassroomId != classroomId ||
        _activeWeek != week) {
      return;
    }

    result.fold(
      (failure) => emit(GetWeeklyPlansFailure(failure.message)),
      (response) => emit(GetWeeklyPlansSuccess(response)),
    );
  }
}
