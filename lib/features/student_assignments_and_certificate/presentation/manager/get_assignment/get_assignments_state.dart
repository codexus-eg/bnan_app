import 'package:bnan_app/features/student_assignments_and_certificate/data/models/assignment_model.dart';

abstract class GetAssignmentsState {}

class GetAssignmentsInitial extends GetAssignmentsState {}

class GetAssignmentsLoading extends GetAssignmentsState {}

class GetAssignmentsSuccess extends GetAssignmentsState {
  final List<AssignmentModel> assignments;

  GetAssignmentsSuccess({required this.assignments});
}

class GetAssignmentsFailure extends GetAssignmentsState {
  final String errorMessage;

  GetAssignmentsFailure({required this.errorMessage});
}