import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';

sealed class GetMyEnrollmentsState {}

final class GetMyEnrollmentsInitial extends GetMyEnrollmentsState {}

final class GetMyEnrollmentsLoading extends GetMyEnrollmentsState {}

final class GetMyEnrollmentsSuccess extends GetMyEnrollmentsState {
  final List<StudentEnrollmentModel> enrollments;

  GetMyEnrollmentsSuccess({
    required this.enrollments,
  });
}

final class GetMyEnrollmentsFailure extends GetMyEnrollmentsState {
  final String errorMessage;

  GetMyEnrollmentsFailure({
    required this.errorMessage,
  });
}