import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';

class GulfScheduleRequest {
  const GulfScheduleRequest({
    required this.classroomSubject,
    required this.schedule,
  });

  final String classroomSubject;
  final List<GulfScheduleEntry> schedule;

  Map<String, dynamic> toJson() => {
    'classroomSubject': classroomSubject,
    'schedule': schedule.map((entry) => entry.toJson()).toList(growable: false),
  };
}
