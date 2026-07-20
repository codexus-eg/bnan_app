sealed class TeacherRequestActionsState {}

final class TeacherRequestActionsInitial
    extends TeacherRequestActionsState {}

final class TeacherRequestActionsLoading
    extends TeacherRequestActionsState {}

final class ApproveTeacherRequestSuccess
    extends TeacherRequestActionsState {}

final class RejectTeacherRequestSuccess
    extends TeacherRequestActionsState {}

final class TeacherRequestActionsFailure
    extends TeacherRequestActionsState {
  final String message;

  TeacherRequestActionsFailure(this.message);
}