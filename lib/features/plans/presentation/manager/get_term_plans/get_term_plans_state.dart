import 'package:bnan_app/features/plans/data/models/term_plans_response_model.dart';

sealed class GetTermPlansState {}

final class GetTermPlansInitial extends GetTermPlansState {}

final class GetTermPlansLoading extends GetTermPlansState {}

final class GetTermPlansSuccess extends GetTermPlansState {
  GetTermPlansSuccess(this.response);

  final TermPlansResponseModel response;
}

final class GetTermPlansFailure extends GetTermPlansState {
  GetTermPlansFailure(this.message);

  final String message;
}
