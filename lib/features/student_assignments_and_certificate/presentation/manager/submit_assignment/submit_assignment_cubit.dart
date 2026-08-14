import 'package:bnan_app/features/student_assignments_and_certificate/data/repo/student_assignments_repo.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/submit_assignment/submit_assignment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitAssignmentCubit extends Cubit<SubmitAssignmentState> {
  SubmitAssignmentCubit(this.assignmentsRepo)
    : super(SubmitAssignmentInitial());

  final StudentAssignmentsRepo assignmentsRepo;

  Future<void> submitAssignment({
    required String assignmentId,
    required String filePath,
  }) async {
    if (isClosed) return;
    emit(SubmitAssignmentLoading(assignmentId: assignmentId));

    final result = await assignmentsRepo.submitAssignment(
      assignmentId: assignmentId,
      filePath: filePath,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(SubmitAssignmentFailure(errorMessage: failure.message));
      },
      (response) {
        emit(SubmitAssignmentSuccess(message: response.message));
      },
    );
  }
}
