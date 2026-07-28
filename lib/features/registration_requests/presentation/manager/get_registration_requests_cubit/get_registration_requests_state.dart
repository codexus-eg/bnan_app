import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_requests_pagination_model.dart';

sealed class GetRegistrationRequestsState {}

final class GetRegistrationRequestsInitial
    extends GetRegistrationRequestsState {}

final class GetRegistrationRequestsLoading
    extends GetRegistrationRequestsState {}

final class GetRegistrationRequestsSuccess
    extends GetRegistrationRequestsState {
  GetRegistrationRequestsSuccess({
    required this.requests,
    required this.pagination,
  });

  final List<RegistrationRequestModel> requests;
  final RegistrationRequestsPaginationModel pagination;
}

final class GetRegistrationRequestsLoadingMore
    extends GetRegistrationRequestsState {
  GetRegistrationRequestsLoadingMore({
    required this.requests,
    required this.pagination,
  });

  final List<RegistrationRequestModel> requests;
  final RegistrationRequestsPaginationModel pagination;
}

final class GetRegistrationRequestsFailure
    extends GetRegistrationRequestsState {
  GetRegistrationRequestsFailure({required this.errorMessage});

  final String errorMessage;
}

final class GetRegistrationRequestsLoadMoreFailure
    extends GetRegistrationRequestsState {
  GetRegistrationRequestsLoadMoreFailure({
    required this.requests,
    required this.pagination,
    required this.errorMessage,
  });

  final List<RegistrationRequestModel> requests;
  final RegistrationRequestsPaginationModel pagination;
  final String errorMessage;
}
