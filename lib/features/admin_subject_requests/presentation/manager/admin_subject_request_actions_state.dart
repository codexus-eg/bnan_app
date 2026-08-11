enum AdminSubjectRequestAction { approve, reject }

sealed class AdminSubjectRequestActionsState {
  const AdminSubjectRequestActionsState();
}

final class AdminSubjectRequestActionIdle
    extends AdminSubjectRequestActionsState {
  const AdminSubjectRequestActionIdle();
}

final class AdminSubjectRequestActionLoading
    extends AdminSubjectRequestActionsState {
  const AdminSubjectRequestActionLoading(this.requestId, this.action);
  final String requestId;
  final AdminSubjectRequestAction action;
}

final class AdminSubjectRequestActionSuccess
    extends AdminSubjectRequestActionsState {
  const AdminSubjectRequestActionSuccess(
    this.requestId,
    this.action,
    this.message,
  );
  final String requestId;
  final AdminSubjectRequestAction action;
  final String message;
}

final class AdminSubjectRequestActionFailure
    extends AdminSubjectRequestActionsState {
  const AdminSubjectRequestActionFailure(
    this.requestId,
    this.action,
    this.message, {
    this.code,
    this.statusCode,
  });
  final String requestId;
  final AdminSubjectRequestAction action;
  final String message;
  final String? code;
  final int? statusCode;
}
