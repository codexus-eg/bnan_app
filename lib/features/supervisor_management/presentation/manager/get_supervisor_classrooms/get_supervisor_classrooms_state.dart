import 'package:bnan_app/features/supervisor_management/data/models/get_supervisor_classrooms_response_model.dart';

sealed class GetSupervisorClassroomsState {}

final class GetSupervisorClassroomsInitial
    extends GetSupervisorClassroomsState {}

final class GetSupervisorClassroomsLoading
    extends GetSupervisorClassroomsState {}

final class GetSupervisorClassroomsSuccess
    extends GetSupervisorClassroomsState {
  GetSupervisorClassroomsSuccess(this.response);

  final GetSupervisorClassroomsResponseModel response;
}

final class GetSupervisorClassroomsFailure
    extends GetSupervisorClassroomsState {
  GetSupervisorClassroomsFailure(this.errorMessage);

  final String errorMessage;
}
