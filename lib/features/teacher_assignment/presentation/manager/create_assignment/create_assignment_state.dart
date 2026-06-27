import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';

sealed class CreateAssignmentState {}

final class CreateAssignmentInitial extends CreateAssignmentState {}

final class CreateAssignmentLoading extends CreateAssignmentState {}

final class CreateAssignmentSuccess extends CreateAssignmentState {
  final AssignmentModel assignment;

  CreateAssignmentSuccess({required this.assignment});
}

final class CreateAssignmentFailure extends CreateAssignmentState {
  final String errorMessage;

  CreateAssignmentFailure({required this.errorMessage});
}

final class CreateAssignmentChangeValue extends CreateAssignmentState {}