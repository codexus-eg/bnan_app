sealed class ReviewAssignmentSubmissionState {}

final class ReviewAssignmentSubmissionInitial
    extends ReviewAssignmentSubmissionState {}

final class ReviewAssignmentSubmissionLoading
    extends ReviewAssignmentSubmissionState {
  final String submissionId;

  ReviewAssignmentSubmissionLoading({required this.submissionId});
}

final class ReviewAssignmentSubmissionSuccess
    extends ReviewAssignmentSubmissionState {
  final String submissionId;

  ReviewAssignmentSubmissionSuccess({required this.submissionId});
}

final class ReviewAssignmentSubmissionFailure
    extends ReviewAssignmentSubmissionState {
  final String errorMessage;
  final String submissionId;

  ReviewAssignmentSubmissionFailure({
    required this.errorMessage,
    required this.submissionId,
  });
}
