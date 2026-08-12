import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorIdealTeacherCubit extends Cubit<SupervisorIdealTeacherState> {
  SupervisorIdealTeacherCubit(this.repo)
    : super(const SupervisorIdealTeacherState());
  final SupervisorIdealTeacherRepo repo;

  Future<void> loadTeachers() async {
    if (state.isSubmitting) return;
    emit(state.copyWith(status: SupervisorIdealTeacherStatus.loadingTeachers));
    final result = await repo.getTeachers();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SupervisorIdealTeacherStatus.failure,
          message: failure.message,
        ),
      ),
      (teachers) => emit(
        SupervisorIdealTeacherState(
          status: SupervisorIdealTeacherStatus.teachersLoaded,
          teachers: teachers,
        ),
      ),
    );
  }

  void toggleTeacher(String teacherId) {
    if (state.isSubmitting || teacherId.isEmpty) return;
    final selected = {...state.selectedTeacherIds};
    selected.contains(teacherId)
        ? selected.remove(teacherId)
        : selected.add(teacherId);
    emit(state.copyWith(selectedTeacherIds: selected));
  }

  void selectTeacher(String teacherId) => _setSelected(teacherId, true);

  void unselectTeacher(String teacherId) => _setSelected(teacherId, false);

  void _setSelected(String teacherId, bool value) {
    if (state.isSubmitting || teacherId.isEmpty) return;
    final selected = {...state.selectedTeacherIds};
    value ? selected.add(teacherId) : selected.remove(teacherId);
    emit(state.copyWith(selectedTeacherIds: selected));
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
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: SupervisorIdealTeacherStatus.success,
          selectedTeacherIds: const {},
        ),
      ),
    );
  }

  Future<void> retry() => loadTeachers();
}
