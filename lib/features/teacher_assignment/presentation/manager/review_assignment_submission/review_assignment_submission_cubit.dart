import 'package:bnan_app/features/teacher_assignment/data/model/review_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/review_assignment_submission/review_assignment_submission_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewAssignmentSubmissionCubit
    extends Cubit<ReviewAssignmentSubmissionState> {
  ReviewAssignmentSubmissionCubit(this.assignmentsRepo)
    : super(ReviewAssignmentSubmissionInitial());

  final AssignmentsRepo assignmentsRepo;

  Future<void> reviewSubmission({
    required String assignmentId,
    required String submissionId,
    required int score,
  }) async {
    emit(ReviewAssignmentSubmissionLoading(submissionId: submissionId));

    final result = await assignmentsRepo.reviewSubmission(
      assignmentId: assignmentId,
      submissionId: submissionId,
      request: ReviewAssignmentRequestModel(score: score),
    );

    result.fold(
      (failure) {
        emit(
          ReviewAssignmentSubmissionFailure(
            errorMessage: failure.message,
            submissionId: submissionId,
          ),
        );
      },
      (_) {
        emit(ReviewAssignmentSubmissionSuccess(submissionId: submissionId));
      },
    );
  }
}
