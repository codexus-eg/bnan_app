import 'package:bnan_app/features/teacher_assignment/data/model/get_teacher_assigned_subjects_response_model.dart';

sealed class GetTeacherAssignedSubjectsState {}

final class GetTeacherAssignedSubjectsInitial
    extends GetTeacherAssignedSubjectsState {}

final class GetTeacherAssignedSubjectsLoading
    extends GetTeacherAssignedSubjectsState {}

final class GetTeacherAssignedSubjectsSuccess
    extends GetTeacherAssignedSubjectsState {
  GetTeacherAssignedSubjectsSuccess({required this.response});

  final GetTeacherAssignedSubjectsResponseModel response;
}

final class GetTeacherAssignedSubjectsFailure
    extends GetTeacherAssignedSubjectsState {
  GetTeacherAssignedSubjectsFailure({required this.errorMessage});

  final String errorMessage;
}
