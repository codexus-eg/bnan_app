import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_weekly_plans/get_weekly_plans_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetWeeklyPlansCubit extends Cubit<GetWeeklyPlansState> {
  GetWeeklyPlansCubit(this.plansRepo) : super(GetWeeklyPlansInitial());

  final PlansRepo plansRepo;
  String? _activeClassroomId;
  int? _activeWeek;
  int _requestId = 0;
  final Map<String, WeeklyPlansResponseModel> _cache = {};

  Future<void> getPlansByWeek({required String classroomId, int? week}) async {
    if (isClosed) return;
    _activeClassroomId = classroomId;
    _activeWeek = week;
    final cached = _cache[_key(classroomId, week)];
    if (cached != null) {
      _emitResponse(cached);
      return;
    }
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

    result.fold((failure) => emit(GetWeeklyPlansFailure(failure.message)), (
      response,
    ) {
      _cache[_key(classroomId, week)] = response;
      if (response.data.week > 0) {
        _cache[_key(classroomId, response.data.week)] = response;
      }
      _emitResponse(response);
    });
  }

  Future<void> refreshPlansByWeek({required String classroomId, int? week}) {
    _cache.remove(_key(classroomId, week));
    return getPlansByWeek(classroomId: classroomId, week: week);
  }

  void _emitResponse(WeeklyPlansResponseModel response) => emit(
    response.data.subjects.isEmpty
        ? GetWeeklyPlansEmpty()
        : GetWeeklyPlansSuccess(response),
  );

  String _key(String classroomId, int? week) => '$classroomId:${week ?? 0}';
}
