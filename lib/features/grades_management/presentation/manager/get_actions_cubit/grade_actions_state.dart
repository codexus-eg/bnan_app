sealed class GradeActionsState {}

final class GradeActionsInitial extends GradeActionsState {}

final class CreateGradeLoading extends GradeActionsState {}

final class CreateGradeSuccess extends GradeActionsState {}

final class CreateGradeFailure extends GradeActionsState {
  CreateGradeFailure(this.message);

  final String message;
}

final class DeleteGradeLoading extends GradeActionsState {}

final class DeleteGradeSuccess extends GradeActionsState {}

final class DeleteGradeFailure extends GradeActionsState {
  DeleteGradeFailure(this.message);

  final String message;
}