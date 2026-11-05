import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';

class GulfScheduleRequest {
  const GulfScheduleRequest({
    required this.classroomSubject,
    required this.schedule,
  });

  final String classroomSubject;
  final List<GulfScheduleEntry> schedule;

  Map<String, dynamic> toJson() {
    final seenDays = <String>{};
    final uniqueSchedule = <Map<String, dynamic>>[];
    for (final entry in schedule) {
      final day = entry.day.toLowerCase().trim();
      if (day.isNotEmpty && seenDays.add(day)) {
        uniqueSchedule.add({
          'day': day,
          'startTime': entry.startTime.trim(),
          'endTime': (entry.endTime ?? '').trim(),
        });
      }
    }
    return {
      'classroomSubject': classroomSubject.trim(),
      'schedule': uniqueSchedule,
    };
  }
}
