import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_subjects_cubit/classroom_subjects_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomSubjectsCubit extends Cubit<ClassroomSubjectsState> {
  ClassroomSubjectsCubit(this.repo) : super(const ClassroomSubjectsInitial());

  final ClassroomsRepo repo;

  Future<void> loadSubjects(String classroomId) async {
    if (isClosed) return;
    emit(const ClassroomSubjectsLoading());
    final result = await repo.getClassroomSubjects(classroomId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(ClassroomSubjectsFailure(failure.message)),
      (data) => emit(ClassroomSubjectsLoaded(data: data)),
    );
  }

  Future<void> addSubject({
    required String classroomId,
    required String subjectId,
    String? teacherId,
  }) async {
    final current = state;
    if (isClosed || current is! ClassroomSubjectsLoaded || current.actionLoading) {
      return;
    }
    emit(current.copyWith(actionLoading: true));

    final result = await repo.addClassroomSubject(
      classroomId: classroomId,
      subjectId: subjectId,
      teacherId: teacherId,
    );
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(
        current.copyWith(
          actionLoading: false,
          feedbackMessage: failure.message,
          isError: true,
        ),
      ),
      (_) async => _reloadWithFeedback(
        classroomId: classroomId,
        fallback: current,
        message: S.current.subjectAddedSuccessfully,
      ),
    );
  }

  Future<void> deleteSubject({
    required String classroomId,
    required String classroomSubjectId,
  }) async {
    final current = state;
    if (isClosed || current is! ClassroomSubjectsLoaded || current.actionLoading) {
      return;
    }
    emit(current.copyWith(actionLoading: true));

    final result = await repo.deleteClassroomSubject(
      classroomId: classroomId,
      classroomSubjectId: classroomSubjectId,
    );
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(
        current.copyWith(
          actionLoading: false,
          feedbackMessage: failure.message,
          isError: true,
        ),
      ),
      (_) async => _reloadWithFeedback(
        classroomId: classroomId,
        fallback: current,
        message: S.current.subjectDeletedSuccessfully,
      ),
    );
  }

  Future<void> _reloadWithFeedback({
    required String classroomId,
    required ClassroomSubjectsLoaded fallback,
    required String message,
  }) async {
    final reload = await repo.getClassroomSubjects(classroomId);
    if (isClosed) return;
    reload.fold(
      (failure) => emit(
        fallback.copyWith(
          actionLoading: false,
          feedbackMessage: failure.message,
          isError: true,
        ),
      ),
      (data) => emit(
        ClassroomSubjectsLoaded(data: data, feedbackMessage: message),
      ),
    );
  }
}
