import 'package:bnan_app/features/grades_management/data/models/grades_response_model.dart';

sealed class GetGradesManagementState {}

final class GetGradesInitial extends GetGradesManagementState {}

final class GetGradesLoading extends GetGradesManagementState {}

final class GetGradesSuccess extends GetGradesManagementState {
  GetGradesSuccess({required this.grades});

  final GradesResponseModel grades;
}

final class GetGradesFailure extends GetGradesManagementState {
  GetGradesFailure({required this.errorMessage});

  final String errorMessage;
}
