import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedule_response_model.dart';

sealed class CreateEgyptianScheduleState {}

final class CreateEgyptianScheduleInitial extends CreateEgyptianScheduleState {}

final class CreateEgyptianScheduleLoading extends CreateEgyptianScheduleState {}

final class CreateEgyptianScheduleSuccess extends CreateEgyptianScheduleState {
  final EgyptianScheduleResponseModel response;

  CreateEgyptianScheduleSuccess(this.response);
}

final class CreateEgyptianScheduleFailure extends CreateEgyptianScheduleState {
  final String message;

  CreateEgyptianScheduleFailure(this.message);
}
