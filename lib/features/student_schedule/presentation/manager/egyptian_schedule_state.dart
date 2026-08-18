import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';

enum EgyptianScheduleStatus { initial, loading, success, failure }

class EgyptianScheduleState {
  const EgyptianScheduleState({
    this.status = EgyptianScheduleStatus.initial,
    this.week,
    this.error = '',
  });

  final EgyptianScheduleStatus status;
  final EgyptianScheduleWeek? week;
  final String error;

  EgyptianScheduleState copyWith({
    EgyptianScheduleStatus? status,
    EgyptianScheduleWeek? week,
    String? error,
  }) => EgyptianScheduleState(
    status: status ?? this.status,
    week: week ?? this.week,
    error: error ?? this.error,
  );
}
