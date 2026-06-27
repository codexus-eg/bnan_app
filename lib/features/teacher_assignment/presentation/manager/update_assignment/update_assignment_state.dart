import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';

sealed class UpdateAssignmentState {}

final class UpdateAssignmentInitial extends UpdateAssignmentState {}

final class UpdateAssignmentLoading extends UpdateAssignmentState {}

final class UpdateAssignmentSuccess extends UpdateAssignmentState {
  final AssignmentModel assignment;

  UpdateAssignmentSuccess({required this.assignment});
}

final class UpdateAssignmentFailure extends UpdateAssignmentState {
  final String errorMessage;

  UpdateAssignmentFailure({required this.errorMessage});
}