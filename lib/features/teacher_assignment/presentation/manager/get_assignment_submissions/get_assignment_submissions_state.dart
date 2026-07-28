import 'package:bnan_app/features/teacher_assignment/data/model/assignment_submissions_response_model.dart';

sealed class GetAssignmentSubmissionsState {}

final class GetAssignmentSubmissionsInitial
    extends GetAssignmentSubmissionsState {}

final class GetAssignmentSubmissionsLoading
    extends GetAssignmentSubmissionsState {}

final class GetAssignmentSubmissionsSuccess
    extends GetAssignmentSubmissionsState {
  final AssignmentSubmissionsResponseModel submissions;

  GetAssignmentSubmissionsSuccess({
    required this.submissions,
  });
}

final class GetAssignmentSubmissionsFailure
    extends GetAssignmentSubmissionsState {
  final String errorMessage;

  GetAssignmentSubmissionsFailure({
    required this.errorMessage,
  });
}