import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_pagination_model.dart';

sealed class TeacherRegistrationRequestsState {}

final class TeacherRequestsInitial extends TeacherRegistrationRequestsState {}

final class TeacherRequestsLoading extends TeacherRegistrationRequestsState {}

final class TeacherRequestsEmpty extends TeacherRegistrationRequestsState {}

final class TeacherRequestsFailure extends TeacherRegistrationRequestsState {
  TeacherRequestsFailure(this.message);
  final String message;
}

abstract class TeacherRequestsDataState
    extends TeacherRegistrationRequestsState {
  TeacherRequestsDataState(this.requests, this.pagination);
  final List<RegistrationRequestModel> requests;
  final TeacherRequestsPaginationModel pagination;
}

final class TeacherRequestsSuccess extends TeacherRequestsDataState {
  TeacherRequestsSuccess(super.requests, super.pagination);
}

final class TeacherRequestsLoadingMore extends TeacherRequestsDataState {
  TeacherRequestsLoadingMore(super.requests, super.pagination);
}

final class TeacherRequestsLoadMoreFailure extends TeacherRequestsDataState {
  TeacherRequestsLoadMoreFailure(
    super.requests,
    super.pagination,
    this.message,
  );
  final String message;
}
