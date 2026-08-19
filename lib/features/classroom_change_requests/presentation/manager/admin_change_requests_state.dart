import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';

sealed class AdminChangeRequestsState {
  const AdminChangeRequestsState();
}

final class AdminChangeRequestsInitial extends AdminChangeRequestsState {
  const AdminChangeRequestsInitial();
}

final class AdminChangeRequestsLoading extends AdminChangeRequestsState {
  const AdminChangeRequestsLoading();
}

final class AdminChangeRequestsSuccess extends AdminChangeRequestsState {
  const AdminChangeRequestsSuccess(this.requests);
  final List<ClassroomChangeRequestModel> requests;
}

final class AdminChangeRequestsFailure extends AdminChangeRequestsState {
  const AdminChangeRequestsFailure(this.message);
  final String message;
}
