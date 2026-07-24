sealed class DeleteEgyptianScheduleState {}

final class DeleteEgyptianScheduleInitial extends DeleteEgyptianScheduleState {}

final class DeleteEgyptianScheduleLoading extends DeleteEgyptianScheduleState {}

final class DeleteEgyptianScheduleSuccess extends DeleteEgyptianScheduleState {}

final class DeleteEgyptianScheduleFailure extends DeleteEgyptianScheduleState {
  final String message;

  DeleteEgyptianScheduleFailure(this.message);
}
