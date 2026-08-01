import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/plans/data/models/parent_child_plans_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_plan_child_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_parent_plans/get_parent_plans_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetParentPlansCubit extends Cubit<GetParentPlansState> {
  GetParentPlansCubit(this.repo) : super(GetParentPlansInitial());

  final PlansRepo repo;
  List<ParentPlanChildModel> children = const [];
  List<ParentChildPlansModel> allChildrenPlans = const [];
  ParentChildPlansModel? currentPlan;
  String? selectedChildId;
  String selectedChildName = '';
  int selectedWeek = 1;
  int _requestId = 0;

  List<int> get availableWeeks {
    final weeks = <int>{};
    for (final plan in allChildrenPlans) {
      if (plan.week > 0) weeks.add(plan.week);
    }
    return weeks.toList()..sort();
  }

  WeeklyPlansResponseModel? get currentWeeklyPlan {
    final plan = currentPlan;
    if (plan == null) return null;
    return WeeklyPlansResponseModel(
      success: true,
      results: plan.subjects.length,
      data: WeeklyPlansDataModel(
        classroom:
            plan.classrooms.firstOrNull ??
            PlanClassroomModel(
              id: selectedChildId ?? '',
              name: selectedChildName,
            ),
        week: selectedWeek,
        subjects: plan.subjects,
      ),
    );
  }

  Future<void> loadParentPlans() async {
    final requestId = ++_requestId;
    emit(GetParentPlansLoading());
    final result = await repo.getParentChildren();
    if (!_isCurrent(requestId)) return;
    final response = _childrenResponse(result);
    if (response == null) return;
    children = response.data;
    if (children.isEmpty) return emit(GetParentPlansSuccess());
    selectedChildId = children.first.id;
    selectedChildName = children.first.fullName;
    await _loadPlans(requestId, selectInitialWeek: true);
  }

  Future<void> retry() async {
    if (children.isEmpty) return loadParentPlans();
    final requestId = ++_requestId;
    emit(GetParentPlansLoading());
    await _loadPlans(requestId);
  }

  void selectChild(String? childId) {
    if (childId == null || childId == selectedChildId) return;
    for (final child in children) {
      if (child.id != childId) continue;
      selectedChildId = child.id;
      selectedChildName = child.fullName;
      _selectCurrentPlan();
      emit(GetParentPlansSuccess());
      return;
    }
  }

  void selectWeek(int? week) {
    if (week == null || week < 1 || week == selectedWeek) return;
    selectedWeek = week;
    _selectCurrentPlan();
    emit(GetParentPlansSuccess());
  }

  Future<void> _loadPlans(
    int requestId, {
    bool selectInitialWeek = false,
  }) async {
    final result = await repo.getParentChildrenPlans();
    if (!_isCurrent(requestId)) return;
    final response = _plansResponse(result);
    if (response == null) return;
    allChildrenPlans = response.data;
    if (selectInitialWeek) _selectFirstAvailableWeek();
    _selectCurrentPlan();
    emit(GetParentPlansSuccess());
  }

  void _selectFirstAvailableWeek() {
    for (final plan in allChildrenPlans) {
      if (plan.student.id == selectedChildId && plan.week > 0) {
        selectedWeek = plan.week;
        return;
      }
    }
  }

  void _selectCurrentPlan() {
    currentPlan = null;
    for (final plan in allChildrenPlans) {
      if (plan.student.id == selectedChildId && plan.week == selectedWeek) {
        currentPlan = plan;
        return;
      }
    }
  }

  ParentChildrenResponseModel? _childrenResponse(
    Either<Failure, ParentChildrenResponseModel> result,
  ) {
    ParentChildrenResponseModel? response;
    result.fold(
      (failure) => emit(GetParentPlansFailure(failure.message)),
      (value) => response = value,
    );
    return response;
  }

  ParentChildrenPlansResponseModel? _plansResponse(
    Either<Failure, ParentChildrenPlansResponseModel> result,
  ) {
    ParentChildrenPlansResponseModel? response;
    result.fold(
      (failure) => emit(GetParentPlansFailure(failure.message)),
      (value) => response = value,
    );
    return response;
  }

  bool _isCurrent(int requestId) => !isClosed && requestId == _requestId;
}
