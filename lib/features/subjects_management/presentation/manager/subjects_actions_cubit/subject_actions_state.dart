sealed class SubjectActionsState {}

final class SubjectActionsInitial extends SubjectActionsState {}

final class AddSubjectLoading extends SubjectActionsState {}

final class AddSubjectSuccess extends SubjectActionsState {}

final class AddSubjectFailure extends SubjectActionsState {
  AddSubjectFailure(this.message);

  final String message;
}

final class UpdateSubjectLoading extends SubjectActionsState {}

final class UpdateSubjectSuccess extends SubjectActionsState {}

final class UpdateSubjectFailure extends SubjectActionsState {
  UpdateSubjectFailure(this.message);

  final String message;
}
