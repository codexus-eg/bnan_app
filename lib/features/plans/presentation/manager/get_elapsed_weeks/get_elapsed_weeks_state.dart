import 'package:bnan_app/features/plans/data/models/elapsed_weeks_response_model.dart';

sealed class GetElapsedWeeksState {}

final class GetElapsedWeeksInitial extends GetElapsedWeeksState {}

final class GetElapsedWeeksLoading extends GetElapsedWeeksState {}

final class GetElapsedWeeksSuccess extends GetElapsedWeeksState {
  GetElapsedWeeksSuccess(this.response);

  final ElapsedWeeksResponseModel response;
}

final class GetElapsedWeeksFailure extends GetElapsedWeeksState {
  GetElapsedWeeksFailure(this.message);

  final String message;
}
