import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTeacherAssignmentsCubit extends Cubit<GetTeacherAssignmentsState> {
  GetTeacherAssignmentsCubit(this.assignmentsRepo)
    : super(GetTeacherAssignmentsInitial());

  final AssignmentsRepo assignmentsRepo;

  Future<void> getAssignments({String? status}) async {
    emit(GetTeacherAssignmentsLoading());

    final result = await assignmentsRepo.getAssignments(status: status);

    result.fold(
      (failure) {
        emit(GetTeacherAssignmentsFailure(errorMessage: failure.message));
      },
      (assignments) {
        emit(GetTeacherAssignmentsSuccess(assignments: assignments));
      },
    );
  }
}