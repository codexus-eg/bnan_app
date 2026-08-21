import 'dart:math' as math;

import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_mode.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/parent_evaluation_child_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_evaluations_request_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadOnlyWeeklyEvaluationsCubit
    extends Cubit<ReadOnlyWeeklyEvaluationsState> {
  ReadOnlyWeeklyEvaluationsCubit(this.repo)
    : super(const ReadOnlyWeeklyEvaluationsState());

  final WeeklyEvaluationsReadRepo repo;
  int _requestId = 0;

  Future<void> loadForStudent({int? week, String? classroomId}) async {
    final requestId = ++_requestId;
    emit(
      ReadOnlyWeeklyEvaluationsState(
        role: ReadOnlyEvaluationsRole.student,
        status: ReadOnlyEvaluationsStatus.loading,
        isLoading: true,
        selectedWeek: week,
      ),
    );
    final classroomsResult = await repo.getMyClassrooms();
    if (!_isCurrent(requestId)) return;
    final failure = classroomsResult.fold((value) => value, (_) => null);
    if (failure != null) return _emitFailure(failure.message);
    final available = classroomsResult.getOrElse(() => const []);
    if (available.isEmpty) return _emitNoClassrooms();
    final selectedClassroomId = available.first.id;
    emit(
      state.copyWith(
        classrooms: available,
        selectedClassroomId: selectedClassroomId,
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
        final classrooms = _classroomsFor(child);
        final classroomId = classrooms.firstOrNull?.id;
        emit(
          state.copyWith(
            children: stableChildren,
            selectedChildId: childId,
            classrooms: classrooms,
            selectedClassroomId: classroomId,
            hasLoadedChildren: true,
          ),
        );
        if (classroomId == null) return _emitNoClassrooms();
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
    final classrooms = _classroomsFor(child);
    final classroomId = classrooms.firstOrNull?.id;
    emit(
      state.copyWith(
        selectedChildId: id,
        classrooms: classrooms,
        selectedClassroomId: classroomId,
        isLoading: true,
        isChangingChild: true,
        isChangingWeek: false,
        isChangingClassroom: false,
        data: null,
        failureMessage: null,
        hasNoClassroom: false,
      ),
    );
    if (classroomId == null) return _emitNoClassrooms();
    await _loadEvaluations(
      requestId: requestId,
      week: state.selectedWeek,
      studentId: id,
    );
  }

  Future<void> selectClassroom(String classroomId) async {
    final id = classroomId.trim();
    if (id.isEmpty ||
        id == state.selectedClassroomId ||
        !state.classrooms.any((item) => item.id == id)) {
      return;
    }
    final requestId = ++_requestId;
    emit(
      state.copyWith(
        selectedClassroomId: id,
        isLoading: true,
        isChangingChild: false,
        isChangingWeek: false,
        isChangingClassroom: true,
        data: null,
        failureMessage: null,
      ),
    );
    await _loadEvaluations(
      requestId: requestId,
      week: state.selectedWeek,
      studentId: state.role == ReadOnlyEvaluationsRole.parent
          ? state.selectedChildId
          : null,
    );
  }

  Future<void> selectWeek(int week) async {
    if (week < 1 ||
        week == state.selectedWeek ||
        state.role == null ||
        state.selectedClassroomId == null ||
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
        isChangingClassroom: false,
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
    if (state.selectedClassroomId == null) {
      if (state.role == ReadOnlyEvaluationsRole.student) {
        return loadForStudent(week: state.selectedWeek);
      }
      return;
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
  }) async {
    final classroomId = state.selectedClassroomId;
    if (classroomId == null) return _emitNoClassrooms();
    final child = _selectedChild(studentId);
    logReadOnlyEvaluationsRequest(
      role: state.role?.name ?? 'unknown',
      studentProfileId: studentId,
      userId: child?.userId,
      classroomId: classroomId,
      week: week,
    );
    final result = await repo.getMyEvaluations(
      week: week,
      studentId: studentId,
      classroomId: classroomId,
    );
    if (!_isCurrent(requestId)) return;
    result.fold((failure) => _emitFailure(failure.message), (response) {
      final data = response.data;
      final responseWeek = data.week ?? week ?? state.selectedWeek;
      final previousMax = state.maxAvailableWeek ?? 0;
      final nextMax = math.max(previousMax, responseWeek ?? 0);
      emit(
        state.copyWith(
          status: _isEmpty(data)
              ? ReadOnlyEvaluationsStatus.empty
              : ReadOnlyEvaluationsStatus.success,
          isLoading: false,
          isChangingChild: false,
          isChangingWeek: false,
          isChangingClassroom: false,
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

  List<ReadEvaluationReferenceModel> _classroomsFor(
    ParentEvaluationChildModel child,
  ) {
    final ids = <String>{};
    return [
      for (final classroom in [
        if (child.classroom != null) child.classroom!,
        ...child.classrooms,
      ])
        if (classroom.id.isNotEmpty && ids.add(classroom.id)) classroom,
    ];
  }

  ParentEvaluationChildModel? _selectedChild(String? studentId) {
    for (final child in state.children) {
      if (child.id == studentId) return child;
    }
    return null;
  }

  void _emitNoClassrooms() => emit(
    state.copyWith(
      status: ReadOnlyEvaluationsStatus.empty,
      isLoading: false,
      isChangingChild: false,
      isChangingWeek: false,
      isChangingClassroom: false,
      selectedClassroomId: null,
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
      isChangingClassroom: false,
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
