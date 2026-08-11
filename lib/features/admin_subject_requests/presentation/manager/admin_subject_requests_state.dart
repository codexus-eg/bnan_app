import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_model.dart';

sealed class AdminSubjectRequestsState {
  const AdminSubjectRequestsState();
}

final class AdminSubjectRequestsInitial extends AdminSubjectRequestsState {
  const AdminSubjectRequestsInitial();
}

final class AdminSubjectRequestsLoading extends AdminSubjectRequestsState {
  const AdminSubjectRequestsLoading();
}

final class AdminSubjectRequestsSuccess extends AdminSubjectRequestsState {
  const AdminSubjectRequestsSuccess({
    required this.requests,
    this.isLoadingMore = false,
    this.loadMoreError,
  });
  final List<AdminSubjectRequestModel> requests;
  final bool isLoadingMore;
  final String? loadMoreError;
}

final class AdminSubjectRequestsFailure extends AdminSubjectRequestsState {
  const AdminSubjectRequestsFailure(this.message);
  final String message;
}
