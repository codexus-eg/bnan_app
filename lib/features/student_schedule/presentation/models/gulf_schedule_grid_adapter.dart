import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/digital_schedule_grid_data.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';

DigitalScheduleGridData adaptGulfStudentSchedule(
  List<GulfClassroom> classrooms,
) {
  final times = <String>{};
  final days = <String>{};
  final cells = <String, List<DigitalScheduleGridItem>>{};
  final timeLabels = <String, String>{};
  final gulf = classrooms.where(
    (item) => item.curriculum?.registrationMode == 'gulf',
  );
  for (final classroom in gulf) {
    for (final entry in classroom.entries) {
      times.add(entry.startTime);
      timeLabels.putIfAbsent(
        entry.startTime,
        () => ScheduleTimeUtils.range(entry.startTime, entry.endTime),
      );
      days.add(entry.day);
      cells
          .putIfAbsent('${entry.day}|${entry.startTime}', () => [])
          .add(
            DigitalScheduleGridItem(
              classroom.subject?.name ?? '',
              classroom.name,
            ),
          );
    }
  }
  return DigitalScheduleGridData(
    days: lessonDays.where(days.contains).toList(),
    times: times.toList()..sort(),
    cells: cells,
    timeLabels: timeLabels,
  );
}
