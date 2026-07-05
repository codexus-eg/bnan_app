import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_curriculums_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/bulk_assign_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'teacher_subject_assignment_actions_state.dart';

class TeacherSubjectAssignmentActionsCubit extends Cubit<TeacherSubjectAssignmentActionsState> {
  TeacherSubjectAssignmentActionsCubit(this.repo) : super(const TeacherSubjectAssignmentActionsInitial());

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

  Future<void> bulkAssignTeachingAssignments({
    required String teacherId,
    required List<TeachingAssignmentRequestModel> assignments,
  }) async {
    emit(const BulkAssignTeachingAssignmentsLoading());

    final result = await repo.bulkAssignTeachingAssignments(
      teacherId: teacherId,
      assignments: assignments,
    );
    
    result.fold(
      (failure) => emit(BulkAssignTeachingAssignmentsFailure(failure.message)),
      (response) => emit(BulkAssignTeachingAssignmentsSuccess(response: response)),
    );
  }
}
