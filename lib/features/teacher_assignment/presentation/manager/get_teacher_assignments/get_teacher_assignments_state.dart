import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assignment_response_model.dart';

sealed class GetTeacherAssignmentsState {}

final class GetTeacherAssignmentsInitial extends GetTeacherAssignmentsState {}

final class GetTeacherAssignmentsLoading extends GetTeacherAssignmentsState {}

final class GetTeacherAssignmentsSuccess extends GetTeacherAssignmentsState {
  final TeacherAssignmentsResponseModel assignments;

  GetTeacherAssignmentsSuccess({required this.assignments});
}

final class GetTeacherAssignmentsFailure extends GetTeacherAssignmentsState {
  final String errorMessage;

  GetTeacherAssignmentsFailure({required this.errorMessage});
}