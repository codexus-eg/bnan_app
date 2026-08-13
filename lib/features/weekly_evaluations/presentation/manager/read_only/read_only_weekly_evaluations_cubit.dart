import 'dart:math' as math;

import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_mode.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/parent_evaluation_child_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_evaluations_request_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';

class ReadOnlyWeeklyEvaluationsCubit
    extends Cubit<ReadOnlyWeeklyEvaluationsState> {
  ReadOnlyWeeklyEvaluationsCubit(this.repo)
    : super(const ReadOnlyWeeklyEvaluationsState());

  final WeeklyEvaluationsReadRepo repo;
  int _requestId = 0;

  Future<void> loadForStudent({int? week}) async {
    final requestId = ++_requestId;
    emit(
      ReadOnlyWeeklyEvaluationsState(
        role: ReadOnlyEvaluationsRole.student,
        status: ReadOnlyEvaluationsStatus.loading,
        isLoading: true,
        selectedWeek: week,
      ),
    );
    await _loadEvaluations(requestId: requestId, week: week);
  }

  Future<void> loadForParent() async {
    final requestId = ++_requestId;
    emit(
      const ReadOnlyWeeklyEvaluationsState(
        role: ReadOnlyEvaluationsRole.parent,
        status: ReadOnlyEvaluationsStatus.loading,
        isLoading: true,
      ),
    );
    final result = await repo.getParentChildren();
    if (!_isCurrent(requestId)) return;
    await result.fold<Future<void>>(
      (failure) async => _emitFailure(failure.message),
      (children) async {
        final stableChildren = List<ParentEvaluationChildModel>.unmodifiable(
          children,
        );
        if (stableChildren.isEmpty) {
          emit(
            state.copyWith(
              status: ReadOnlyEvaluationsStatus.empty,
              isLoading: false,
              children: stableChildren,
              hasLoadedChildren: true,
            ),
          );
          return;
        }
        final childId = stableChildren.first.id;
        final child = stableChildren.first;
        emit(
          state.copyWith(
            children: stableChildren,
            selectedChildId: childId,
            hasLoadedChildren: true,
          ),
        );
        if (_hasNoClassroom(child)) {
          _emitNoClassroom();
          return;
        }
        final evaluationsId = ++_requestId;
        await _loadEvaluations(requestId: evaluationsId, studentId: childId);
      },
    );
  }

  Future<void> selectChild(String childId) async {
    final id = childId.trim();
    if (state.role != ReadOnlyEvaluationsRole.parent ||
        id.isEmpty ||
        id == state.selectedChildId ||
        !state.children.any((child) => child.id == id)) {
      return;
    }
    final requestId = ++_requestId;
    final child = state.children.firstWhere((item) => item.id == id);
    emit(
      state.copyWith(
        selectedChildId: id,
        maxAvailableWeek: null,
        isLoading: true,
        isChangingChild: true,
        isChangingWeek: false,
        failureMessage: null,
        hasNoClassroom: false,
      ),
    );
    if (_hasNoClassroom(child)) {
      _emitNoClassroom();
      return;
    }
    await _loadEvaluations(
      requestId: requestId,
      studentId: id,
      resetMaxAvailableWeek: true,
    );
  }

  Future<void> selectWeek(int week) async {
    if (week < 1 ||
        week == state.selectedWeek ||
        state.role == null ||
        (state.role == ReadOnlyEvaluationsRole.parent &&
            state.children.isEmpty)) {
      return;
    }
    final requestId = ++_requestId;
    final studentId = state.role == ReadOnlyEvaluationsRole.parent
        ? state.selectedChildId
        : null;
    emit(
      state.copyWith(
        selectedWeek: week,
        isLoading: true,
        isChangingChild: false,
        isChangingWeek: true,
        failureMessage: null,
      ),
    );
    await _loadEvaluations(
      requestId: requestId,
      week: week,
      studentId: studentId,
    );
  }

  Future<void> retry() async {
    if (state.isLoading || state.role == null) return;
    if (state.role == ReadOnlyEvaluationsRole.parent &&
        (!state.hasLoadedChildren || state.children.isEmpty)) {
      return loadForParent();
    }
    final requestId = ++_requestId;
    emit(state.copyWith(isLoading: true, failureMessage: null));
    await _loadEvaluations(
      requestId: requestId,
      week: state.selectedWeek,
      studentId: state.role == ReadOnlyEvaluationsRole.parent
          ? state.selectedChildId
          : null,
    );
  }

  Future<void> _loadEvaluations({
    required int requestId,
    int? week,
    String? studentId,
    bool resetMaxAvailableWeek = false,
  }) async {
    final child = _selectedChild(studentId);
    logReadOnlyEvaluationsRequest(
      role: state.role?.name ?? 'unknown',
      studentProfileId: studentId,
      userId: child?.userId,
      week: week,
    );
    final result = await repo.getMyEvaluations(
      week: week,
      studentId: studentId,
    );
    if (!_isCurrent(requestId)) return;
    result.fold((failure) => _emitFailure(failure.message), (response) {
      final data = response.data;
      final responseWeek = data.week ?? week ?? state.selectedWeek;
      final previousMax = state.maxAvailableWeek ?? 0;
      final nextMax = resetMaxAvailableWeek
          ? responseWeek
          : math.max(previousMax, responseWeek ?? 0);
      emit(
        state.copyWith(
          status: _isEmpty(data)
              ? ReadOnlyEvaluationsStatus.empty
              : ReadOnlyEvaluationsStatus.success,
          isLoading: false,
          isChangingChild: false,
          isChangingWeek: false,
          selectedWeek: responseWeek,
          maxAvailableWeek: nextMax == 0 ? null : nextMax,
          data: data,
          failureMessage: null,
          hasNoClassroom: false,
        ),
      );
    });
  }

  bool _isEmpty(MeWeeklyEvaluationsDataModel data) => switch (data.mode) {
    EvaluationMode.gulf => data.classrooms.isEmpty,
    EvaluationMode.egyptian => data.subjects.isEmpty,
    EvaluationMode.unknown => data.classrooms.isEmpty && data.subjects.isEmpty,
  };

  bool _hasNoClassroom(ParentEvaluationChildModel child) =>
      child.registrationMode == RegistrationMode.gulf && !child.hasClassroom;

  ParentEvaluationChildModel? _selectedChild(String? studentId) {
    for (final child in state.children) {
      if (child.id == studentId) return child;
    }
    return null;
  }

  void _emitNoClassroom() => emit(
    state.copyWith(
      status: ReadOnlyEvaluationsStatus.empty,
      isLoading: false,
      isChangingChild: false,
      isChangingWeek: false,
      data: null,
      failureMessage: null,
      hasNoClassroom: true,
    ),
  );

  void _emitFailure(String message) => emit(
    state.copyWith(
      status: ReadOnlyEvaluationsStatus.failure,
      isLoading: false,
      isChangingChild: false,
      isChangingWeek: false,
      failureMessage: message,
    ),
  );

  bool _isCurrent(int requestId) => !isClosed && requestId == _requestId;

  @override
  Future<void> close() {
    _requestId++;
    return super.close();
  }
}
