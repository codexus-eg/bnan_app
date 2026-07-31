import 'package:bnan_app/features/plans/data/models/create_plan_response_model.dart';

sealed class PlansActionsState {}

final class PlansActionsInitial extends PlansActionsState {}

final class CreateDailyPlanLoading extends PlansActionsState {}

final class CreateDailyPlanSuccess extends PlansActionsState {
  CreateDailyPlanSuccess(this.response);

  final CreatePlanResponseModel response;
}

final class CreateDailyPlanFailure extends PlansActionsState {
  CreateDailyPlanFailure(this.message);

  final String message;
}

final class UploadTermPlanLoading extends PlansActionsState {}

final class UploadTermPlanSuccess extends PlansActionsState {
  UploadTermPlanSuccess(this.response);

  final CreatePlanResponseModel response;
}

final class UploadTermPlanFailure extends PlansActionsState {
  UploadTermPlanFailure(this.message);

  final String message;
}
