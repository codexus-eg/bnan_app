import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'teacher_subject_assignments_state.dart';

class TeacherSubjectAssignmentsCubit extends Cubit<TeacherSubjectAssignmentsState> {
  TeacherSubjectAssignmentsCubit(this.repo) : super(const TeacherSubjectAssignmentsInitial());

  final TeacherSubjectAssignmentRepo repo;

  Future<void> getTeacherTeachingAssignments() async {
    emit(const GetTeachingAssignmentsLoading());

    final result = await repo.getTeacherTeachingAssignments();
    result.fold(
      (failure) => emit(GetTeachingAssignmentsFailure(failure.message)),
      (response) {
        if (response.data.isEmpty) {
          emit(const GetTeachingAssignmentsEmpty());
        } else {
          emit(GetTeachingAssignmentsSuccess(assignments: response.data));
        }
      },
    );
  }
}
