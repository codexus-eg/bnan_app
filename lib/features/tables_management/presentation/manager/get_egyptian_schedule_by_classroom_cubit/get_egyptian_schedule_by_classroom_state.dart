import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedule_response_model.dart';

sealed class GetEgyptianScheduleByClassroomState {}

final class GetEgyptianScheduleByClassroomInitial
    extends GetEgyptianScheduleByClassroomState {}

final class GetEgyptianScheduleByClassroomLoading
    extends GetEgyptianScheduleByClassroomState {}

final class GetEgyptianScheduleByClassroomSuccess
    extends GetEgyptianScheduleByClassroomState {
  final EgyptianScheduleResponseModel response;

  GetEgyptianScheduleByClassroomSuccess(this.response);
}

final class GetEgyptianScheduleByClassroomFailure
    extends GetEgyptianScheduleByClassroomState {
  final String message;

  GetEgyptianScheduleByClassroomFailure(this.message);
}
