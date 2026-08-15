import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';

enum ParentGulfScheduleStatus { initial, loading, success, failure }

class ParentGulfScheduleState {
  const ParentGulfScheduleState({
    this.status = ParentGulfScheduleStatus.initial,
    this.classrooms = const [],
    this.currentWeek,
    this.currentWeekStart,
    this.timezone,
    this.selectedWeek,
    this.maxWeek,
    this.error = '',
  });

  final ParentGulfScheduleStatus status;
  final List<GulfClassroom> classrooms;
  final int? currentWeek, selectedWeek, maxWeek;
  final DateTime? currentWeekStart;
  final String? timezone;
  final String error;

  ParentGulfScheduleState copyWith({
    ParentGulfScheduleStatus? status,
    String? error,
  }) => ParentGulfScheduleState(
    status: status ?? this.status,
    classrooms: classrooms,
    currentWeek: currentWeek,
    currentWeekStart: currentWeekStart,
    timezone: timezone,
    selectedWeek: selectedWeek,
    maxWeek: maxWeek,
    error: error ?? this.error,
  );
}
