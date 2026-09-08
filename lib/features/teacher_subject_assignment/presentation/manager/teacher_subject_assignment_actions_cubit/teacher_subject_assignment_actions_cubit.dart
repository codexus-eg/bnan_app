import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_curriculums_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/unassign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'teacher_subject_assignment_actions_state.dart';

class TeacherSubjectAssignmentActionsCubit
    extends Cubit<TeacherSubjectAssignmentActionsState> {
  TeacherSubjectAssignmentActionsCubit(this.repo)
    : super(const TeacherSubjectAssignmentActionsInitial());

  final TeacherSubjectAssignmentRepo repo;

  Future<void> assignCurriculumsToTeacher({
    required String teacherId,
    required List<String> curriculumIds,
  }) async {
    if (isClosed) return;
    emit(const AssignCurriculumsLoading());

    final result = await repo.assignCurriculumsToTeacher(
      teacherId: teacherId,
      curriculumIds: curriculumIds,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(AssignCurriculumsFailure(failure.message));
      },
      (response) {
        if (isClosed) return;
        emit(AssignCurriculumsSuccess(response: response));
      },
    );
  }

  Future<void> assignTeacher({
    required String teacherId,
    required String curriculumId,
    required String gradeId,
    required String classroomId,
    required String subjectId,
  }) async {
    if (isClosed || state is AssignTeacherLoading) return;
    emit(const AssignTeacherLoading());
    final result = await repo.assignTeacher(
      teacherId: teacherId,
      request: AssignTeacherRequestModel(
        curriculumId: curriculumId,
        gradeId: gradeId,
        classroomId: classroomId,
        subjectId: subjectId,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(AssignTeacherFailure(failure.message));
      },
      (response) {
        if (isClosed) return;
        emit(AssignTeacherSuccess(response: response));
      },
    );
  }

  Future<void> unassignTeacherFromClassroom({
    required String teacherId,
    required String classroomId,
  }) async {
    if (isClosed) return;
    final safeTeacherId = teacherId.trim();
    final safeClassroomId = classroomId.trim();
    if (safeTeacherId.isEmpty || safeClassroomId.isEmpty) return;

    emit(UnassignTeacherLoading(safeTeacherId, safeClassroomId));
    final result = await repo.unassignTeacherFromClassroom(
      teacherId: safeTeacherId,
      classroomId: safeClassroomId,
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          UnassignTeacherFailure(
            safeTeacherId,
            safeClassroomId,
            failure.message,
          ),
        );
      },
      (response) {
        if (isClosed) return;
        emit(UnassignTeacherSuccess(safeTeacherId, safeClassroomId, response));
      },
    );
  }
}
