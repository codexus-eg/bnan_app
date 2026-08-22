enum AdminChangeRequestAction { approve, reject }

sealed class AdminChangeRequestActionsState {
  const AdminChangeRequestActionsState();
}

final class AdminChangeRequestActionIdle
    extends AdminChangeRequestActionsState {
  const AdminChangeRequestActionIdle();
}

final class AdminChangeRequestActionLoading
    extends AdminChangeRequestActionsState {
  const AdminChangeRequestActionLoading(this.id, this.action);
  final String id;
  final AdminChangeRequestAction action;
}

final class AdminChangeRequestActionSuccess
    extends AdminChangeRequestActionsState {
  const AdminChangeRequestActionSuccess(this.id, this.action);
  final String id;
  final AdminChangeRequestAction action;
}

final class AdminChangeRequestActionFailure
    extends AdminChangeRequestActionsState {
  const AdminChangeRequestActionFailure(this.id, this.message);
  final String id, message;
}
