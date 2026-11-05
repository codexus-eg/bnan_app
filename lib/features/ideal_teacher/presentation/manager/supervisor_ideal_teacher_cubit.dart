import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorIdealTeacherCubit extends Cubit<SupervisorIdealTeacherState> {
  SupervisorIdealTeacherCubit(this.repo)
    : super(const SupervisorIdealTeacherState());

  static const limit = 20;
  final SupervisorIdealTeacherRepo repo;

  PlanClassroomOption? selectedClassroom;
  int page = 0, pages = 1, _requestId = 0;
  bool _loadingMore = false;
  String _classroomsSignature = '';

  Future<void> setClassrooms(List<PlanClassroomOption> classrooms) async {
    final signature = classrooms.map((item) => item.id).join('|');
    if (signature == _classroomsSignature) return;
    _classroomsSignature = signature;
    if (classrooms.isEmpty) {
      _requestId++;
      selectedClassroom = null;
      emit(
        state.copyWith(
          status: SupervisorIdealTeacherStatus.loaded,
          ranking: const [],
          rankingResponse: null,
        ),
      );
      return;
    }
    final currentId = selectedClassroom?.id;
    final current = classrooms
        .where((item) => item.id == currentId)
        .firstOrNull;
    await selectClassroom(current ?? classrooms.first);
  }

  Future<void> selectClassroom(PlanClassroomOption? classroom) async {
    if (classroom == null || classroom.id.trim().isEmpty) return;
    if (selectedClassroom?.id == classroom.id && state.rankingResponse != null) {
      return;
    }
    selectedClassroom = classroom;
    emit(
      state.copyWith(
        status: SupervisorIdealTeacherStatus.loading,
        selectedTeacherIds: const {},
        message: '',
        ranking: const [],
        rankingResponse: null,
      ),
    );
    await _fetchRanking(1, ++_requestId);
  }

  Future<void> refresh() async {
    if (selectedClassroom == null) return;
    await _fetchRanking(1, ++_requestId, keepData: true);
  }

  Future<void> loadMore() async {
    if (_loadingMore || page >= pages || selectedClassroom == null) return;
    _loadingMore = true;
    emit(state.copyWith(status: SupervisorIdealTeacherStatus.loadingMore));
    await _fetchRanking(page + 1, _requestId, append: true);
    _loadingMore = false;
  }

  Future<void> _fetchRanking(
    int targetPage,
    int reqId, {
    bool append = false,
    bool keepData = false,
  }) async {
    final classroomId = selectedClassroom?.id ?? '';
    if (classroomId.isEmpty) return;

    final result = await repo.getRanking(
      classroomId: classroomId,
      page: targetPage,
      limit: limit,
    );

    if (_requestId != reqId || isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SupervisorIdealTeacherStatus.failure,
          message: failure.message,
        ),
      ),
      (response) {
        page = response.page;
        pages = response.pages;
        final updated = append
            ? [...state.ranking, ...response.ranking]
            : response.ranking;
        emit(
          state.copyWith(
            status: SupervisorIdealTeacherStatus.loaded,
            rankingResponse: response,
            ranking: updated,
            message: '',
          ),
        );
      },
    );
  }

  void toggleTeacher(String teacherId) {
    if (state.isSubmitting || teacherId.isEmpty) return;
    final selected = {...state.selectedTeacherIds};
    selected.contains(teacherId)
        ? selected.remove(teacherId)
        : selected.add(teacherId);
    emit(
      state.copyWith(
        status: SupervisorIdealTeacherStatus.loaded,
        message: '',
        selectedTeacherIds: selected,
      ),
    );
  }

  void selectTeacher(String teacherId) => _setSelected(teacherId, true);

  void unselectTeacher(String teacherId) => _setSelected(teacherId, false);

  void clearSelection() {
    if (state.isSubmitting || state.selectedTeacherIds.isEmpty) return;
    emit(
      state.copyWith(
        status: SupervisorIdealTeacherStatus.loaded,
        message: '',
        selectedTeacherIds: const {},
      ),
    );
  }

  void _setSelected(String teacherId, bool value) {
    if (state.isSubmitting || teacherId.isEmpty) return;
    final selected = {...state.selectedTeacherIds};
    value ? selected.add(teacherId) : selected.remove(teacherId);
    emit(
      state.copyWith(
        status: SupervisorIdealTeacherStatus.loaded,
        message: '',
        selectedTeacherIds: selected,
      ),
    );
  }

  Future<bool> addPointAdjustment({
    required String teacherId,
    required int points,
    required String category,
    required String reason,
  }) async {
    final classroomId = selectedClassroom?.id ?? '';
    if (classroomId.isEmpty || state.isSubmitting) return false;

    emit(state.copyWith(status: SupervisorIdealTeacherStatus.submitting));
    final result = await repo.addPointAdjustment(
      classroomId: classroomId,
      teacherId: teacherId,
      points: points,
      category: category,
      reason: reason,
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: SupervisorIdealTeacherStatus.failure,
            message: failure.message,
          ),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(status: SupervisorIdealTeacherStatus.adjustmentSuccess),
        );
        refresh();
        return true;
      },
    );
  }

  Future<void> loadPointAdjustments(String teacherId) async {
    final classroomId = selectedClassroom?.id ?? '';
    if (classroomId.isEmpty) return;

    emit(state.copyWith(loadingAdjustments: true));
    final result = await repo.getPointAdjustments(
      classroomId: classroomId,
      teacherId: teacherId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingAdjustments: false,
          message: failure.message,
        ),
      ),
      (adjustments) => emit(
        state.copyWith(
          loadingAdjustments: false,
          adjustments: adjustments,
        ),
      ),
    );
  }

  Future<bool> revokePointAdjustment({
    required String adjustmentId,
    required String teacherId,
  }) async {
    final classroomId = selectedClassroom?.id ?? '';
    if (classroomId.isEmpty || state.isSubmitting) return false;

    emit(state.copyWith(status: SupervisorIdealTeacherStatus.submitting));
    final result = await repo.revokePointAdjustment(
      classroomId: classroomId,
      adjustmentId: adjustmentId,
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: SupervisorIdealTeacherStatus.failure,
            message: failure.message,
          ),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(status: SupervisorIdealTeacherStatus.adjustmentSuccess),
        );
        loadPointAdjustments(teacherId);
        refresh();
        return true;
      },
    );
  }

  Future<void> submitIdealTeachers({String? signerName}) async {
    if (state.selectedTeacherIds.isEmpty || state.isSubmitting) return;
    emit(state.copyWith(status: SupervisorIdealTeacherStatus.submitting));
    final result = await repo.issueIdealTeachers(
      teacherIds: state.selectedTeacherIds.toList(growable: false),
      signerName: signerName,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SupervisorIdealTeacherStatus.failure,
          message: failure.message,
          issuanceEventId: state.issuanceEventId + 1,
          issuanceSuccess: false,
          issuanceMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: SupervisorIdealTeacherStatus.success,
          issuanceEventId: state.issuanceEventId + 1,
          issuanceSuccess: true,
          issuanceMessage: null,
          selectedTeacherIds: const {},
        ),
      ),
    );
  }

  void setSearchQuery(String query) {
    emit(
      state.copyWith(
        status: SupervisorIdealTeacherStatus.loaded,
        message: '',
        searchQuery: query,
      ),
    );
  }

  void setActiveTab(IdealTeacherTab tab) {
    emit(state.copyWith(activeTab: tab));
  }

  Future<void> loadTeachers() async {
    emit(state.copyWith(status: SupervisorIdealTeacherStatus.loading));
    final result = await repo.getTeachers();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SupervisorIdealTeacherStatus.failure,
          message: failure.message,
        ),
      ),
      (teachers) => emit(
        state.copyWith(
          status: SupervisorIdealTeacherStatus.loaded,
          teachers: teachers,
        ),
      ),
    );
  }

  Future<void> retry() =>
      state.activeTab == IdealTeacherTab.classroomPoints
          ? refresh()
          : loadTeachers();
}

