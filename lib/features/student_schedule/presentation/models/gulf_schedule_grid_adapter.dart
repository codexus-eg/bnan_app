import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:bnan_app/features/student_schedule/presentation/models/digital_schedule_grid_data.dart';

DigitalScheduleGridData adaptGulfStudentSchedule(
  List<GulfClassroom> classrooms,
) {
  final times = <String>{};
  final days = <String>{};
  final cells = <String, List<DigitalScheduleGridItem>>{};
  final gulf = classrooms.where(
    (item) => item.curriculum?.registrationMode == 'gulf',
  );
  for (final classroom in gulf) {
    for (final entry in classroom.entries) {
      times.add(entry.startTime);
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
  );
}
