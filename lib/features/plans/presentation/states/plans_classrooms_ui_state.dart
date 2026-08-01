import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';

sealed class PlansClassroomsUiState {
  const PlansClassroomsUiState();
}

final class PlansClassroomsLoading extends PlansClassroomsUiState {
  const PlansClassroomsLoading();
}

final class PlansClassroomsSuccess extends PlansClassroomsUiState {
  const PlansClassroomsSuccess(this.classrooms);

  final List<PlanClassroomOption> classrooms;
}

final class PlansClassroomsFailure extends PlansClassroomsUiState {
  const PlansClassroomsFailure(this.message);

  final String message;
}
