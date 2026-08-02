sealed class WeeklyEvaluationsState {
  const WeeklyEvaluationsState();
}

final class WeeklyEvaluationsInitial extends WeeklyEvaluationsState {}

final class EvaluationWeeksLoading extends WeeklyEvaluationsState {}

final class EvaluationsLoading extends WeeklyEvaluationsState {}

final class EvaluationsLoaded extends WeeklyEvaluationsState {}

final class EvaluationsEmpty extends WeeklyEvaluationsState {}

final class EvaluationsFailure extends WeeklyEvaluationsState {
  const EvaluationsFailure(this.message);
  final String message;
}

final class EvaluationSaving extends WeeklyEvaluationsState {}

final class EvaluationSaved extends WeeklyEvaluationsState {}

final class EvaluationSaveFailure extends WeeklyEvaluationsState {
  const EvaluationSaveFailure(this.message);
  final String message;
}

final class ParentChildrenLoading extends WeeklyEvaluationsState {}
