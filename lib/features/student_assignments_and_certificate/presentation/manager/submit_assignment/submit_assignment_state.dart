abstract class SubmitAssignmentState {}

class SubmitAssignmentInitial extends SubmitAssignmentState {}

class SubmitAssignmentLoading extends SubmitAssignmentState {
  final String assignmentId;

  SubmitAssignmentLoading({required this.assignmentId});
}

class SubmitAssignmentSuccess extends SubmitAssignmentState {
  final String message;

  SubmitAssignmentSuccess({required this.message});
}

class SubmitAssignmentFailure extends SubmitAssignmentState {
  final String errorMessage;

  SubmitAssignmentFailure({required this.errorMessage});
}