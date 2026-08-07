import 'package:bnan_app/features/teacher_request_groups/data/models/accepted_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_state.dart';

final class TeacherRequestAccepting extends TeacherRequestsDataState {
  TeacherRequestAccepting(super.requests, super.pagination, this.requestId);
  final String requestId;
}

final class TeacherRequestAccepted extends TeacherRequestsDataState {
  TeacherRequestAccepted(super.requests, super.pagination, this.result);
  final AcceptedTeacherRequestModel result;
}

final class TeacherRequestAlreadyAssigned extends TeacherRequestsDataState {
  TeacherRequestAlreadyAssigned(super.requests, super.pagination);
}

final class TeacherRequestNotEligible extends TeacherRequestsDataState {
  TeacherRequestNotEligible(super.requests, super.pagination);
}

final class TeacherRequestNotFound extends TeacherRequestsDataState {
  TeacherRequestNotFound(super.requests, super.pagination);
}

final class TeacherRequestAcceptFailure extends TeacherRequestsDataState {
  TeacherRequestAcceptFailure(super.requests, super.pagination, this.message);
  final String message;
}
