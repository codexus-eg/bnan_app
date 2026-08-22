import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';

sealed class PendingTeacherRequestsState {}

final class PendingTeacherRequestsInitial extends PendingTeacherRequestsState {}

final class PendingTeacherRequestsLoading extends PendingTeacherRequestsState {}

final class PendingTeacherRequestsSuccess extends PendingTeacherRequestsState {
  final TeacherRequestResponseModel response;

  PendingTeacherRequestsSuccess(this.response);
}

final class PendingTeacherRequestsFailure extends PendingTeacherRequestsState {
  final String message;

  PendingTeacherRequestsFailure(this.message);
}
