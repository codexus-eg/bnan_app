import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_assignment_submissions/get_assignment_submissions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAssignmentSubmissionsCubit
    extends Cubit<GetAssignmentSubmissionsState> {
  GetAssignmentSubmissionsCubit(this.assignmentsRepo)
    : super(GetAssignmentSubmissionsInitial());

  final AssignmentsRepo assignmentsRepo;

  Future<void> getAssignmentSubmissions({
    required String assignmentId,
  }) async {
    emit(GetAssignmentSubmissionsLoading());

    final result = await assignmentsRepo.getAssignmentSubmissions(
      assignmentId: assignmentId,
    );

    result.fold(
      (failure) {
        emit(
          GetAssignmentSubmissionsFailure(
            errorMessage: failure.message,
          ),
        );
      },
      (submissions) {
        emit(
          GetAssignmentSubmissionsSuccess(
            submissions: submissions,
          ),
        );
      },
    );
  }
}