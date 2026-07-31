import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';

sealed class GetWeeklyPlansState {}

final class GetWeeklyPlansInitial extends GetWeeklyPlansState {}

final class GetWeeklyPlansLoading extends GetWeeklyPlansState {}

final class GetWeeklyPlansSuccess extends GetWeeklyPlansState {
  GetWeeklyPlansSuccess(this.response);

  final WeeklyPlansResponseModel response;
}

final class GetWeeklyPlansFailure extends GetWeeklyPlansState {
  GetWeeklyPlansFailure(this.message);

  final String message;
}
