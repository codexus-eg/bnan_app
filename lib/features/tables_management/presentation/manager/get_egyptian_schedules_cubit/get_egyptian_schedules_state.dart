import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';

sealed class GetEgyptianSchedulesState {}

final class GetEgyptianSchedulesInitial extends GetEgyptianSchedulesState {}

final class GetEgyptianSchedulesLoading extends GetEgyptianSchedulesState {}

final class GetEgyptianSchedulesSuccess extends GetEgyptianSchedulesState {
  final EgyptianSchedulesResponseModel response;

  GetEgyptianSchedulesSuccess(this.response);
}

final class GetEgyptianSchedulesFailure extends GetEgyptianSchedulesState {
  final String message;

  GetEgyptianSchedulesFailure(this.message);
}
