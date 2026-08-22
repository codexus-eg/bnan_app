import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';

enum ParentGulfScheduleStatus { initial, loading, success, failure }

class ParentGulfScheduleState {
  const ParentGulfScheduleState({
    this.status = ParentGulfScheduleStatus.initial,
    this.classrooms = const [],
    this.error = '',
  });

  final ParentGulfScheduleStatus status;
  final List<GulfClassroom> classrooms;
  final String error;

  ParentGulfScheduleState copyWith({
    ParentGulfScheduleStatus? status,
    String? error,
  }) => ParentGulfScheduleState(
    status: status ?? this.status,
    classrooms: classrooms,
    error: error ?? this.error,
  );
}
