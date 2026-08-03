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
    emit(const AssignCurriculumsLoading());

    final result = await repo.assignCurriculumsToTeacher(
      teacherId: teacherId,
      curriculumIds: curriculumIds,
    );

    result.fold(
      (failure) => emit(AssignCurriculumsFailure(failure.message)),
      (response) => emit(AssignCurriculumsSuccess(response: response)),
    );
  }

  Future<void> assignTeacher({
    required String teacherId,
    required String curriculumId,
    required String gradeId,
    required String classroomId,
    required String subjectId,
    required num pricePerSession,
  }) async {
    if (state is AssignTeacherLoading) return;
    emit(const AssignTeacherLoading());
    final result = await repo.assignTeacher(
      teacherId: teacherId,
      request: AssignTeacherRequestModel(
        curriculumId: curriculumId,
        gradeId: gradeId,
        classroomId: classroomId,
        subjectId: subjectId,
        pricePerSession: pricePerSession,
      ),
    );
    result.fold(
      (failure) => emit(AssignTeacherFailure(failure.message)),
      (response) => emit(AssignTeacherSuccess(response: response)),
    );
  }

  Future<void> unassignTeacherFromClassroom({
    required String teacherId,
    required String classroomId,
  }) async {
    final safeTeacherId = teacherId.trim();
    final safeClassroomId = classroomId.trim();
    if (safeTeacherId.isEmpty || safeClassroomId.isEmpty) return;

    emit(UnassignTeacherLoading(safeTeacherId, safeClassroomId));
    final result = await repo.unassignTeacherFromClassroom(
      teacherId: safeTeacherId,
      classroomId: safeClassroomId,
    );
    result.fold(
      (failure) => emit(
        UnassignTeacherFailure(safeTeacherId, safeClassroomId, failure.message),
      ),
      (response) => emit(
        UnassignTeacherSuccess(safeTeacherId, safeClassroomId, response),
      ),
    );
  }
}
