sealed class SubjectActionsState {}

final class SubjectActionsInitial extends SubjectActionsState {}

final class AddSubjectLoading extends SubjectActionsState {}

final class AddSubjectSuccess extends SubjectActionsState {}

final class AddSubjectFailure extends SubjectActionsState {
  AddSubjectFailure(this.message, this.code);

  final String message;
  final String? code;
}

final class UpdateSubjectLoading extends SubjectActionsState {}

final class UpdateSubjectSuccess extends SubjectActionsState {}

final class UpdateSubjectFailure extends SubjectActionsState {
  UpdateSubjectFailure(this.message, this.code);

  final String message;
  final String? code;
}
