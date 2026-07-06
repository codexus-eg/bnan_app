sealed class ClassroomActionsState {}

final class ClassroomActionsInitial extends ClassroomActionsState {}

final class CreateClassroomLoading extends ClassroomActionsState {}

final class CreateClassroomSuccess extends ClassroomActionsState {}

final class CreateClassroomFailure extends ClassroomActionsState {
  final String message;

  CreateClassroomFailure(this.message);
}

final class UpdateClassroomLoading extends ClassroomActionsState {}

final class UpdateClassroomSuccess extends ClassroomActionsState {}

final class UpdateClassroomFailure extends ClassroomActionsState {
  final String message;

  UpdateClassroomFailure(this.message);
}
