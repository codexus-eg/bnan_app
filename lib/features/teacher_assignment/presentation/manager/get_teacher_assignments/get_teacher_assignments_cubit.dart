import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assignment_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTeacherAssignmentsCubit extends Cubit<GetTeacherAssignmentsState> {
  GetTeacherAssignmentsCubit(this.assignmentsRepo)
    : super(GetTeacherAssignmentsInitial());

  final AssignmentsRepo assignmentsRepo;
  int _requestId = 0;

  Future<void> getAssignments({String? status}) async {
    if (isClosed) return;
    final requestId = ++_requestId;
    emit(GetTeacherAssignmentsLoading());

    final result = await assignmentsRepo.getAssignments(status: status);
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (failure) {
        emit(GetTeacherAssignmentsFailure(errorMessage: failure.message));
      },
      (assignments) {
        emit(GetTeacherAssignmentsSuccess(assignments: assignments));
      },
    );
  }

  void removeAssignment(String assignmentId) {
    if (isClosed) return;
    final current = state;
    if (current is! GetTeacherAssignmentsSuccess) return;
    final assignments = current.assignments.assignments
        .where((assignment) => assignment.id != assignmentId)
        .toList(growable: false);
    emit(
      GetTeacherAssignmentsSuccess(
        assignments: TeacherAssignmentsResponseModel(assignments: assignments),
      ),
    );
  }
}
