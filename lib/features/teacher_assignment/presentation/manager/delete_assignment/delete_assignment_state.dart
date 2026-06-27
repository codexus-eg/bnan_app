sealed class DeleteAssignmentState {}

final class DeleteAssignmentInitial extends DeleteAssignmentState {}

final class DeleteAssignmentLoading extends DeleteAssignmentState {}

final class DeleteAssignmentSuccess extends DeleteAssignmentState {}

final class DeleteAssignmentFailure extends DeleteAssignmentState {
  final String errorMessage;

  DeleteAssignmentFailure({required this.errorMessage});
}