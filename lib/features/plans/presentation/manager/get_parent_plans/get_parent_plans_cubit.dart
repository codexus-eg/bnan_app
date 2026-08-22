import 'package:bnan_app/features/plans/data/models/elapsed_weeks_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_plan_child_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_parent_plans/get_parent_plans_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetParentPlansCubit extends Cubit<GetParentPlansState> {
  GetParentPlansCubit(this.repo) : super(GetParentPlansInitial());

  final PlansRepo repo;
  List<ParentPlanChildModel> children = const [];
  ElapsedWeeksResponseModel? weeksMetadata;
  WeeklyPlansResponseModel? currentWeeklyPlan;
  String? selectedChildId;
  String selectedChildName = '';
  int selectedWeek = 1;
  int _requestId = 0;

  List<int> get availableWeeks {
    final count = weeksMetadata?.data.weeksCount ?? 0;
    return List.generate(count, (index) => index + 1);
  }

  PlanClassroomModel? get selectedClassroom {
    for (final child in children) {
      if (child.id == selectedChildId) return child.classroom;
    }
    return null;
  }

  Future<void> loadParentPlans() async {
    final requestId = ++_requestId;
    emit(GetParentPlansLoading());
    final result = await repo.getParentChildren();
    if (!_isCurrent(requestId)) return;
    ParentChildrenResponseModel? response;
    result.fold(
      (failure) => emit(GetParentPlansFailure(failure.message)),
      (value) => response = value,
    );
    if (response == null) return;
    children = response!.data;
    if (children.isEmpty) return emit(GetParentPlansEmpty());
    _selectChildValue(children.first);
    await _loadWeeks(requestId);
  }

  Future<void> selectChild(String? childId) async {
    if (childId == null || childId == selectedChildId) return;
    for (final child in children) {
      if (child.id != childId) continue;
      final requestId = ++_requestId;
      _selectChildValue(child);
      emit(GetParentPlansLoading());
      await _loadWeeks(requestId);
      return;
    }
  }

  Future<void> selectWeek(int? week) async {
    if (week == null ||
        !availableWeeks.contains(week) ||
        week == selectedWeek) {
      return;
    }
    final requestId = ++_requestId;
    selectedWeek = week;
    currentWeeklyPlan = null;
    emit(GetParentPlansLoading());
    await _loadWeek(requestId);
  }

  Future<void> retry() async {
    if (children.isEmpty) return loadParentPlans();
    final requestId = ++_requestId;
    emit(GetParentPlansLoading());
    if (weeksMetadata == null) {
      await _loadWeeks(requestId);
    } else {
      await _loadWeek(requestId);
    }
  }

  void _selectChildValue(ParentPlanChildModel child) {
    selectedChildId = child.id;
    selectedChildName = child.fullName;
    selectedWeek = 1;
    weeksMetadata = null;
    currentWeeklyPlan = null;
  }

  Future<void> _loadWeeks(int requestId) async {
    final classroomId = selectedClassroom?.id ?? '';
    if (classroomId.isEmpty) return emit(GetParentPlansEmpty());
    final result = await repo.getElapsedWeeks(classroomId: classroomId);
    if (!_isCurrent(requestId)) return;
    ElapsedWeeksResponseModel? response;
    result.fold(
      (failure) => emit(GetParentPlansFailure(failure.message)),
      (value) => response = value,
    );
    if (response == null) return;
    weeksMetadata = response;
    final data = response!.data;
    if (data.weeksCount < 1) return emit(GetParentPlansEmpty());
    selectedWeek = data.currentWeek >= 1 && data.currentWeek <= data.weeksCount
        ? data.currentWeek
        : data.weeksCount;
    await _loadWeek(requestId);
  }

  Future<void> _loadWeek(int requestId) async {
    final classroomId = selectedClassroom?.id ?? '';
    if (classroomId.isEmpty) return emit(GetParentPlansEmpty());
    final result = await repo.getPlansByWeek(
      classroomId: classroomId,
      week: selectedWeek,
    );
    if (!_isCurrent(requestId)) return;
    result.fold((failure) => emit(GetParentPlansFailure(failure.message)), (
      response,
    ) {
      currentWeeklyPlan = response;
      emit(
        response.data.subjects.isEmpty
            ? GetParentPlansEmpty()
            : GetParentPlansSuccess(),
      );
    });
  }

  bool _isCurrent(int requestId) => !isClosed && requestId == _requestId;
}
