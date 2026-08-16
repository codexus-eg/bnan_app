import 'package:bnan_app/features/tables_management/presentation/manager/egyptian_schedule_management_cubit.dart';

enum EgyptianLessonAddAvailability { disabled, noSubjects, available }

EgyptianLessonAddAvailability egyptianLessonAddAvailability(
  EgyptianScheduleState state,
) {
  if (state.status != EgyptianScheduleStatus.ready) {
    return EgyptianLessonAddAvailability.disabled;
  }
  return state.subjects.isEmpty
      ? EgyptianLessonAddAvailability.noSubjects
      : EgyptianLessonAddAvailability.available;
}
