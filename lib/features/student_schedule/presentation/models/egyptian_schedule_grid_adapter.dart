import 'package:bnan_app/features/student_schedule/presentation/models/digital_schedule_grid_data.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';

DigitalScheduleGridData adaptEgyptianSchedule(
  EgyptianScheduleWeek week, {
  required String Function(EgyptianDigitalLesson) secondaryText,
  bool includeJoinAction = false,
}) {
  final times = <String>{};
  final cells = <String, List<DigitalScheduleGridItem>>{};
  final timeLabels = <String, String>{};
  for (final day in week.days) {
    final dayKey = _dayKey(DateTime.tryParse(day.date)?.weekday);
    if (dayKey == null) continue;
    for (final lesson in day.lessons) {
      if (lesson.startTime.isEmpty) continue;
      times.add(lesson.startTime);
      timeLabels.putIfAbsent(
        lesson.startTime,
        () => ScheduleTimeUtils.range(lesson.startTime, lesson.endTime),
      );
      cells
          .putIfAbsent('$dayKey|${lesson.startTime}', () => [])
          .add(
            DigitalScheduleGridItem(
              lesson.subjectName,
              secondaryText(lesson),
              actionClassroomId:
                  includeJoinAction &&
                      lesson.activeSession?.studentCanJoin == true
                  ? lesson.classroomId
                  : null,
            ),
          );
    }
  }
  return DigitalScheduleGridData(
    days: egyptianScheduleDays,
    times: times.toList()..sort(),
    cells: cells,
    timeLabels: timeLabels,
  );
}

const egyptianScheduleDays = [
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
];

String? _dayKey(int? weekday) => switch (weekday) {
  DateTime.sunday => 'sunday',
  DateTime.monday => 'monday',
  DateTime.tuesday => 'tuesday',
  DateTime.wednesday => 'wednesday',
  DateTime.thursday => 'thursday',
  _ => null,
};
